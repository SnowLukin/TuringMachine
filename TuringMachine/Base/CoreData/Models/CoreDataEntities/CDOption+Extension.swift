//
//  CDOption+Extension.swift
//  TuringMachine
//
//  Created by Snow Lukin on 23.11.2023.
//

import Foundation
import CoreData

extension CDOption {

    var unwrappedCombinations: [CDCombination] {
        guard let combinations else { return [] }
        return combinations.compactMap { $0 as? CDCombination }
    }

    var joinedCombinations: String {
        self.unwrappedCombinations
            .map { $0.fromChar.unwrapped }
            .joined(separator: "")
    }

    func getStates() -> [CDMachineState] {
        let algorithm = self.state?.algorithm
        return algorithm?.unwrappedStates ?? []
    }

    func fetchToState() -> CDMachineState? {
        guard let context = self.managedObjectContext else { return nil }
        let id = self.toStateId.unwrapped
        let predicate = NSPredicate(format: "id == %@", id)
        return CDMachineState.find(by: predicate, in: context)
    }
}

extension CDOption: ModelProtocol {

    static func find(for stateId: String, in context: NSManagedObjectContext) -> [CDOption] {
        let predicate = NSPredicate(format: "id == %@", stateId)
        guard let state = CDMachineState.findAll(withPredicate: predicate, in: context).first else {
            return []
        }
        return find(for: state, in: context)
    }

    static func find(for state: CDMachineState, in context: NSManagedObjectContext) -> [CDOption] {
        let predicate = NSPredicate(format: "state == %@", state)
        return CDOption.findAll(withPredicate: predicate, in: context)
    }

    @discardableResult
    static func create(
        id: String = UUID().uuidString,
        combinations: String = "",
        toStateId: String? = nil,
        state: CDMachineState,
        in context: NSManagedObjectContext
    ) throws -> CDOption {
        let option = CDOption(context: context)
        option.id = id
        option.toStateId = (toStateId ?? state.id)

        combinations.forEach { char in
            let char = String(char)
            _ = try? CDCombination.create(fromChar: char, toChar: char, option: option, in: context)
        }

        state.addToOptions(option)
        state.algorithm?.lastEditDate = .now
        try option.save(in: context)
        return option
    }

    func removeCombination(_ combination: CDCombination) throws {
        guard let context = self.managedObjectContext else { return }
        self.removeFromCombinations(combination)
        try combination.delete(from: context)
    }
}

extension CDOption {
    @discardableResult
    static func create(from optionData: Option,
                       state: CDMachineState,
                       in context: NSManagedObjectContext) throws -> CDOption {
        let option = try CDOption.create(
            id: optionData.id,
            toStateId: optionData.toStateId,
            state: state,
            in: context
        )

        optionData.combinations.forEach { combinationData in
            _ = try? CDCombination.create(from: combinationData, option: option, in: context)
        }

        try option.save(in: context)
        return option
    }
}
