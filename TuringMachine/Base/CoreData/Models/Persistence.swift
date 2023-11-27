//
//  Persistence.swift
//  TuringMachine
//
//  Created by Snow Lukin on 30.10.2023.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        let mockGen = MockDataGenerator(context: viewContext)
        mockGen.createData()

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer
    let context: NSManagedObjectContext

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TuringMachine")
        if inMemory {
            // swiftlint:disable force_unwrapping
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
            // swiftlint:enable force_unwrapping
        }

        // Configure the persistent store for automatic migration
        let storeDescription = container.persistentStoreDescriptions.first
        storeDescription?.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
        storeDescription?.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)

        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        context = container.viewContext
    }
}
