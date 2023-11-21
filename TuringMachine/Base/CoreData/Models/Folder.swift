//
//  Folder+CoreDataClass.swift
//  TuringMachine
//
//  Created by Snow Lukin on 20.11.2023.
//
//

import Foundation
import CoreData

@objc(Folder)
public class Folder: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var algorithms: NSOrderedSet?
    
    public var unwrappedAlgorithms: [Algorithm] {
        guard let algorithms else { return [] }
        return algorithms
            .compactMap { $0 as? Algorithm}
            .sorted {
                $0.lastEditDate.unwrappedOrNow < $1.lastEditDate.unwrappedOrNow
            }
    }
}

// MARK: Generated accessors for algorithms
extension Folder {

    @objc(insertObject:inAlgorithmsAtIndex:)
    @NSManaged public func insertIntoAlgorithms(_ value: Algorithm, at idx: Int)

    @objc(removeObjectFromAlgorithmsAtIndex:)
    @NSManaged public func removeFromAlgorithms(at idx: Int)

    @objc(insertAlgorithms:atIndexes:)
    @NSManaged public func insertIntoAlgorithms(_ values: [Algorithm], at indexes: NSIndexSet)

    @objc(removeAlgorithmsAtIndexes:)
    @NSManaged public func removeFromAlgorithms(at indexes: NSIndexSet)

    @objc(replaceObjectInAlgorithmsAtIndex:withObject:)
    @NSManaged public func replaceAlgorithms(at idx: Int, with value: Algorithm)

    @objc(replaceAlgorithmsAtIndexes:withAlgorithms:)
    @NSManaged public func replaceAlgorithms(at indexes: NSIndexSet, with values: [Algorithm])

    @objc(addAlgorithmsObject:)
    @NSManaged public func addToAlgorithms(_ value: Algorithm)

    @objc(removeAlgorithmsObject:)
    @NSManaged public func removeFromAlgorithms(_ value: Algorithm)

    @objc(addAlgorithms:)
    @NSManaged public func addToAlgorithms(_ values: NSOrderedSet)

    @objc(removeAlgorithms:)
    @NSManaged public func removeFromAlgorithms(_ values: NSOrderedSet)

}

extension Folder : Identifiable {

}
