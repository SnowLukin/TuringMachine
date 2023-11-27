//
//  CDCombination+Extension.swift
//  TuringMachine
//
//  Created by Snow Lukin on 23.11.2023.
//

import Foundation
import CoreData

extension CDCombination: ModelProtocol {
    static func find(for optionId: String, in context: NSManagedObjectContext) -> [CDCombination] {
        let predicate = NSPredicate(format: "id == %@", optionId)
        guard let option = CDOption.findAll(withPredicate: predicate, in: context).first else {
            return []
        }
        return find(for: option, in: context)
    }

    static func find(for option: CDOption, in context: NSManagedObjectContext) -> [CDCombination] {
        let predicate = NSPredicate(format: "option == %@", option)
        return CDCombination.findAll(withPredicate: predicate, in: context)
    }

    static func create(
        id: String = UUID().uuidString,
        fromChar: String,
        toChar: String,
        direction: Int = 0,
        option: CDOption,
        in context: NSManagedObjectContext
    ) throws {
        let combination = CDCombination(context: context)
        combination.id = id
        combination.fromChar = fromChar
        combination.toChar = toChar
        combination.directionIndex = Int64(direction)
        option.addToCombinations(combination)
        try combination.save(in: context)
    }

    func update(toChar: String? = nil, fromChar: String? = nil, direction: Direction? = nil) throws {
        guard let context = self.managedObjectContext else { return }
        if let toChar = toChar {
            self.toChar = toChar
        }
        if let fromChar = fromChar {
            self.fromChar = fromChar
        }
        if let direction = direction {
            self.directionIndex = Int64(direction.rawValue)
        }
        try self.save(in: context)
    }
}
