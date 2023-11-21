//
//  CoreDataFetcher.swift
//  TuringMachine
//
//  Created by Snow Lukin on 20.11.2023.
//

import Foundation
import CoreData

struct CoreDataFetcher {
    
    static let shared = CoreDataFetcher()
    private init() {}
    
    // MARK: Entity Array Fetching
    
    func algorithmsForFolder(with id: String, in context: NSManagedObjectContext) -> [Algorithm] {
        let predicate = NSPredicate(format: "id == %@", id)
        guard let folder = fetchEntities(ofType: Folder.self, withPredicate: predicate, in: context).first else {
            return []
        }

        let algorithmPredicate = NSPredicate(format: "folder == %@", folder)
        return fetchEntities(ofType: Algorithm.self, withPredicate: algorithmPredicate, in: context)
    }
    
    func tapesForAlgorithm(with id: String, in context: NSManagedObjectContext) -> [Tape] {
        let predicate = NSPredicate(format: "id == %@", id)
        guard let algorithm = fetchEntities(ofType: Algorithm.self, withPredicate: predicate, in: context).first else {
            return []
        }

        let tapePredicate = NSPredicate(format: "algorithm == %@", algorithm)
        return fetchEntities(ofType: Tape.self, withPredicate: tapePredicate, in: context)
    }
    
    func statesForAlgorithm(with id: String, in context: NSManagedObjectContext) -> [StateQ] {
        let predicate = NSPredicate(format: "id == %@", id)
        guard let algorithm = fetchEntities(ofType: Algorithm.self, withPredicate: predicate, in: context).first else {
            return []
        }
        
        let statePredicate = NSPredicate(format: "algorithm == %@", algorithm)
        return fetchEntities(ofType: StateQ.self, withPredicate: statePredicate, in: context)
    }

    func optionsForState(with id: String, in context: NSManagedObjectContext) -> [Option] {
        let predicate = NSPredicate(format: "id == %@", id)
        guard let state = fetchEntities(ofType: StateQ.self, withPredicate: predicate, in: context).first else {
            return []
        }
        
        let optionPredicate = NSPredicate(format: "state == %@", state)
        return fetchEntities(ofType: Option.self, withPredicate: optionPredicate, in: context)
    }
    
    func combinationForOption(with id: String, in context: NSManagedObjectContext) -> [Combination] {
        let predicate = NSPredicate(format: "id == %@", id)
        guard let option = fetchEntities(ofType: Option.self, withPredicate: predicate, in: context).first else {
            return []
        }
        
        let combinationPredicate = NSPredicate(format: "option == %@", option)
        return fetchEntities(ofType: Combination.self, withPredicate: combinationPredicate, in: context)
    }
    
    // MARK: Generic Fetch
    
    func fetchEntities<T: NSManagedObject>(
        ofType entityType: T.Type,
        withPredicate predicate: NSPredicate?,
        in context: NSManagedObjectContext
    ) -> [T] {
        let entityName = String(describing: entityType)
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.predicate = predicate
        return (try? context.fetch(fetchRequest)) ?? []
    }
}
