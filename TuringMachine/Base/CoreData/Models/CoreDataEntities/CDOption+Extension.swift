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

    static func create(
        id: String = UUID().uuidString,
        combinations: String,
        state: CDMachineState,
        in context: NSManagedObjectContext
    ) throws {
        let option = CDOption(context: context)
        option.id = id
        option.toStateId = state.id

        combinations.forEach { char in
            let char = String(char)
            try? CDCombination.create(fromChar: char, toChar: char, option: option, in: context)
        }

        state.addToOptions(option)
        state.algorithm?.lastEditDate = .now
        try option.save(in: context)
    }

    func removeCombination(_ combination: CDCombination) throws {
        guard let context = self.managedObjectContext else { return }
        self.removeFromCombinations(combination)
        try combination.delete(from: context)
    }
}
