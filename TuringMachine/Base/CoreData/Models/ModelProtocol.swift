//
//  ModelProtocol.swift
//  TuringMachine
//
//  Created by Snow Lukin on 23.11.2023.
//

import Foundation
import CoreData

// Interface of Active Record pattern
protocol ModelProtocol {

}

extension ModelProtocol where Self: NSManagedObject {

    static var all: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: String(describing: self))
        request.sortDescriptors = []
        return request
    }

    static func findAll(
        withPredicate predicate: NSPredicate? = nil,
        in context: NSManagedObjectContext
    ) -> [Self] {
        let entityName = String(describing: self)
        let fetchRequest = NSFetchRequest<Self>(entityName: entityName)
        fetchRequest.predicate = predicate
        return (try? context.fetch(fetchRequest)) ?? []
    }

    static func find(by predicate: NSPredicate? = nil,
                     in context: NSManagedObjectContext) -> Self? {
        findAll(withPredicate: predicate, in: context).first
    }

    func save(in context: NSManagedObjectContext) throws {
        try context.save()
    }

    func delete(from context: NSManagedObjectContext) throws {
        context.delete(self)
        try save(in: context)
    }
}
