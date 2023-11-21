//
//  Algorithm+CoreDataClass.swift
//  TuringMachine
//
//  Created by Snow Lukin on 20.11.2023.
//
//

import Foundation
import CoreData

@objc(Algorithm)
public class Algorithm: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Algorithm> {
        return NSFetchRequest<Algorithm>(entityName: "Algorithm")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var algDescription: String?
    @NSManaged public var createdDate: Date?
    @NSManaged public var lastEditDate: Date?
    @NSManaged public var startingStateId: String?
    @NSManaged public var activeStateId: String?
    @NSManaged public var folder: Folder?
    @NSManaged public var tapes: NSOrderedSet?
    @NSManaged public var states: NSOrderedSet?
    
    public var unwrappedTapes: [Tape] {
        guard let tapes else { return [] }
        return tapes
            .compactMap { $0 as? Tape }
    }
    
    public var unwrappedStates: [StateQ] {
        guard let states else { return [] }
        return states
            .compactMap { $0 as? StateQ }
    }
}

// MARK: Generated accessors for tapes
extension Algorithm {

    @objc(insertObject:inTapesAtIndex:)
    @NSManaged public func insertIntoTapes(_ value: Tape, at idx: Int)

    @objc(removeObjectFromTapesAtIndex:)
    @NSManaged public func removeFromTapes(at idx: Int)

    @objc(insertTapes:atIndexes:)
    @NSManaged public func insertIntoTapes(_ values: [Tape], at indexes: NSIndexSet)

    @objc(removeTapesAtIndexes:)
    @NSManaged public func removeFromTapes(at indexes: NSIndexSet)

    @objc(replaceObjectInTapesAtIndex:withObject:)
    @NSManaged public func replaceTapes(at idx: Int, with value: Tape)

    @objc(replaceTapesAtIndexes:withTapes:)
    @NSManaged public func replaceTapes(at indexes: NSIndexSet, with values: [Tape])

    @objc(addTapesObject:)
    @NSManaged public func addToTapes(_ value: Tape)

    @objc(removeTapesObject:)
    @NSManaged public func removeFromTapes(_ value: Tape)

    @objc(addTapes:)
    @NSManaged public func addToTapes(_ values: NSOrderedSet)

    @objc(removeTapes:)
    @NSManaged public func removeFromTapes(_ values: NSOrderedSet)

}

// MARK: Generated accessors for states
extension Algorithm {

    @objc(insertObject:inStatesAtIndex:)
    @NSManaged public func insertIntoStates(_ value: StateQ, at idx: Int)

    @objc(removeObjectFromStatesAtIndex:)
    @NSManaged public func removeFromStates(at idx: Int)

    @objc(insertStates:atIndexes:)
    @NSManaged public func insertIntoStates(_ values: [StateQ], at indexes: NSIndexSet)

    @objc(removeStatesAtIndexes:)
    @NSManaged public func removeFromStates(at indexes: NSIndexSet)

    @objc(replaceObjectInStatesAtIndex:withObject:)
    @NSManaged public func replaceStates(at idx: Int, with value: StateQ)

    @objc(replaceStatesAtIndexes:withStates:)
    @NSManaged public func replaceStates(at indexes: NSIndexSet, with values: [StateQ])

    @objc(addStatesObject:)
    @NSManaged public func addToStates(_ value: StateQ)

    @objc(removeStatesObject:)
    @NSManaged public func removeFromStates(_ value: StateQ)

    @objc(addStates:)
    @NSManaged public func addToStates(_ values: NSOrderedSet)

    @objc(removeStates:)
    @NSManaged public func removeFromStates(_ values: NSOrderedSet)

}

extension Algorithm : Identifiable {

}
