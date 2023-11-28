//
//  CDMachineState+Extension.swift
//  TuringMachine
//
//  Created by Snow Lukin on 23.11.2023.
//

import Foundation
import CoreData

extension CDMachineState {
    var unwrappedOptions: [CDOption] {
        guard let options else { return [] }
        return options.compactMap { $0 as? CDOption }
    }
}

extension CDMachineState: ModelProtocol {
    static func find(for algorithmId: String, in context: NSManagedObjectContext) -> [CDMachineState] {
        let predicate = NSPredicate(format: "id == %@", algorithmId)
        guard let algorithm = CDAlgorithm.findAll(withPredicate: predicate, in: context).first else {
            return []
        }
        return find(for: algorithm, in: context)
    }

    static func find(for algorithm: CDAlgorithm, in context: NSManagedObjectContext) -> [CDMachineState] {
        let predicate = NSPredicate(format: "algorithm == %@", algorithm)
        return CDMachineState.findAll(withPredicate: predicate, in: context)
    }

    @discardableResult
    static func create(
        id: String = UUID().uuidString,
        name: String,
        options: [CDOption] = [],
        algorithm: CDAlgorithm,
        in context: NSManagedObjectContext
    ) throws -> CDMachineState {
        let state = CDMachineState(context: context)
        state.id = UUID().uuidString
        state.name = name.isEmpty ? "State \(algorithm.unwrappedStates.count)" : name
        algorithm.addToStates(state)
        try state.save(in: context)
        return state
    }

    func removeOption(_ option: CDOption) throws {
        guard let context = self.managedObjectContext else { return }
        self.removeFromOptions(option)
        try option.delete(from: context)
    }
}

extension CDMachineState {
    @discardableResult
    static func create(from stateData: MachineState,
                       algorithm: CDAlgorithm,
                       in context: NSManagedObjectContext) throws -> CDMachineState {
        let state = try CDMachineState.create(
            id: stateData.id,
            name: stateData.name,
            algorithm: algorithm,
            in: context
        )

        stateData.options.forEach { option in
            _ = try? CDOption.create(from: option, state: state, in: context)
        }

        try state.save(in: context)
        return state
    }
}
