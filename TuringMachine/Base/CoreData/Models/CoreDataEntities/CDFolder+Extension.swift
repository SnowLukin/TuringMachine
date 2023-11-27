//
//  CDFolder+Extension.swift
//  TuringMachine
//
//  Created by Snow Lukin on 23.11.2023.
//

import Foundation
import CoreData

extension CDFolder {
    var unwrappedAlgorithms: [CDAlgorithm] {
        guard let algorithms else { return [] }
        return algorithms
            .compactMap { $0 as? CDAlgorithm}
            .sorted {
                $0.lastEditDate.unwrappedOrNow < $1.lastEditDate.unwrappedOrNow
            }
    }

    static func isValidName(_ name: String, in context: NSManagedObjectContext) -> Bool {
        let predicate = NSPredicate(format: "name == %@", name)
        guard CDFolder.find(by: predicate, in: context) != nil else {
            return name.trimmingCharacters(in: .whitespaces) != ""
        }
        return false
    }
}

extension CDFolder: ModelProtocol {
    static func create(
        id: String = UUID().uuidString,
        name: String,
        algorithms: [CDAlgorithm] = [],
        in context: NSManagedObjectContext
    ) throws {
        let folder = CDFolder(context: context)
        folder.id = id
        folder.name = name
        try folder.save(in: context)
    }

    func removeAlgorithm(_ algorithm: CDAlgorithm, in context: NSManagedObjectContext) throws {
        self.removeFromAlgorithms(algorithm)
        try self.save(in: context)
    }
}
