//
//  CDAlgorithm+Extension.swift
//  TuringMachine
//
//  Created by Snow Lukin on 23.11.2023.
//

import Foundation
import CoreData

extension CDAlgorithm {
    var unwrappedStates: [CDMachineState] {
        guard let states else { return [] }
        return states
            .compactMap { $0 as? CDMachineState }
    }

    var unwrappedTapes: [CDTape] {
        guard let tapes else { return [] }
        return tapes
            .compactMap { $0 as? CDTape }
    }

    var isChanged: Bool {
        for tape in self.unwrappedTapes {
            let sameInput = tape.input == tape.workingInput
            let sameHeadIndex = tape.headIndex == tape.workingHeadIndex
            if !sameInput || !sameHeadIndex {
                return true
            }
        }
        return false
    }
}

extension CDAlgorithm: ModelProtocol {

    static func find(for folderId: String, in context: NSManagedObjectContext) -> [CDAlgorithm] {
        let predicate = NSPredicate(format: "id == %@", folderId)
        guard let folder = CDFolder.findAll(withPredicate: predicate, in: context).first else {
            return []
        }
        return find(for: folder, in: context)
    }

    static func find(for folder: CDFolder, in context: NSManagedObjectContext) -> [CDAlgorithm] {
        let predicate = NSPredicate(format: "folder == %@", folder)
        return CDAlgorithm.findAll(withPredicate: predicate, in: context)
    }

    static func create(
        id: String = UUID().uuidString,
        name: String,
        createdDate: Date = .now,
        lastEditDate: Date = .now,
        folder: CDFolder,
        in context: NSManagedObjectContext
    ) throws {
        let name = name.trimmingCharacters(in: .whitespaces)
        let algorithm = CDAlgorithm(context: context)
        algorithm.id = id
        algorithm.name = name
        algorithm.createdDate = createdDate
        algorithm.lastEditDate = lastEditDate
        folder.addToAlgorithms(algorithm)
        try algorithm.save(in: context)
    }

    func removeTape(_ tape: CDTape) throws {
        guard let context = self.managedObjectContext else { return }
        self.removeFromTapes(tape)
        try tape.delete(from: context)
    }

    func removeState(_ state: CDMachineState) throws {
        guard let context = self.managedObjectContext else { return }
        self.removeFromStates(state)
        try state.delete(from: context)
    }

    func updateInfo(with name: String? = nil, description: String? = nil, in context: NSManagedObjectContext) throws {
        if let name = name {
            self.name = name.trimmingCharacters(in: .whitespaces)
        }
        if let description = description {
            self.algDescription = description
        }
        try self.save(in: context)
    }

    func updateStartState(to state: CDMachineState) throws {
        guard let context = self.managedObjectContext else { return }
        self.startingStateId = state.id
        self.activeStateId = state.id
        try self.save(in: context)
    }
}
