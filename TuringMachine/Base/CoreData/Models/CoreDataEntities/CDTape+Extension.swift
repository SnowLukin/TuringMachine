//
//  CDTape+Extension.swift
//  TuringMachine
//
//  Created by Snow Lukin on 23.11.2023.
//

import Foundation
import CoreData

extension CDTape: ModelProtocol {
    static func find(for algorithmId: String, in context: NSManagedObjectContext) -> [CDTape] {
        let predicate = NSPredicate(format: "id == %@", algorithmId)
        guard let algorithm = CDAlgorithm.findAll(withPredicate: predicate, in: context).first else {
            return []
        }
        return find(for: algorithm, in: context)
    }

    static func find(for algorithm: CDAlgorithm, in context: NSManagedObjectContext) -> [CDTape] {
        let predicate = NSPredicate(format: "algorithm == %@", algorithm)
        return CDTape.findAll(withPredicate: predicate, in: context)
    }

    @discardableResult
    static func create(
        id: String = UUID().uuidString,
        name: String,
        input: String = "",
        headIndex: Int = 100,
        algorithm: CDAlgorithm,
        in context: NSManagedObjectContext
    ) throws -> CDTape {
        let tape = CDTape(context: context)
        tape.id = id
        tape.name = name
        let padding = String(repeating: "-", count: 100)
        tape.input = padding + input + padding
        tape.headIndex = Int64(headIndex)
        tape.workingInput = tape.input
        tape.workingHeadIndex = tape.headIndex
        algorithm.addToTapes(tape)
        try tape.save(in: context)
        return tape
    }

    func changeHeadIndex(to index: Int) throws {
        guard let context = self.managedObjectContext else { return }
        self.headIndex = Int64(index)
        self.workingHeadIndex = Int64(index)
        self.algorithm?.lastEditDate = .now
        try self.save(in: context)
    }

    func updateInput(_ text: String) throws {
        guard let context = self.managedObjectContext else { return }
        let padding = String(repeating: "-", count: 100)

        self.input = padding + text + padding
        self.headIndex = 100

        self.workingInput = self.input
        self.workingHeadIndex = self.headIndex

        try self.save(in: context)
    }
}

extension CDTape {
    @discardableResult
    static func create(from tapeData: Tape,
                       algorithm: CDAlgorithm,
                       in context: NSManagedObjectContext) throws -> CDTape {
        let tape = try CDTape.create(
            id: tapeData.id,
            name: tapeData.name,
            input: tapeData.input,
            headIndex: tapeData.headIndex,
            algorithm: algorithm,
            in: context
        )
        return tape
    }
}
