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

    static func create(
        id: String = UUID().uuidString,
        name: String,
        options: [CDOption] = [],
        algorithm: CDAlgorithm,
        in context: NSManagedObjectContext
    ) throws {
        let state = CDMachineState(context: context)
        state.id = UUID().uuidString
        state.name = name.isEmpty ? "State \(algorithm.unwrappedStates.count)" : name
        algorithm.addToStates(state)
        try state.save(in: context)
    }

    func removeOption(_ option: CDOption) throws {
        guard let context = self.managedObjectContext else { return }
        self.removeFromOptions(option)
        try option.delete(from: context)
    }
}
