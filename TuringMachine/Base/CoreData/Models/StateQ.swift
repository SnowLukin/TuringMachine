//
//  StateQ+CoreDataClass.swift
//  TuringMachine
//
//  Created by Snow Lukin on 20.11.2023.
//
//

import Foundation
import CoreData

@objc(StateQ)
public class StateQ: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<StateQ> {
        return NSFetchRequest<StateQ>(entityName: "StateQ")
    }

    @NSManaged public var id: String?
    @NSManaged public var algorithm: Algorithm?
    @NSManaged public var options: NSOrderedSet?
    
    public var unwrappedOptions: [Option] {
        guard let options else { return [] }
        return options.compactMap { $0 as? Option }
    }
}

// MARK: Generated accessors for options
extension StateQ {

    @objc(insertObject:inOptionsAtIndex:)
    @NSManaged public func insertIntoOptions(_ value: Option, at idx: Int)

    @objc(removeObjectFromOptionsAtIndex:)
    @NSManaged public func removeFromOptions(at idx: Int)

    @objc(insertOptions:atIndexes:)
    @NSManaged public func insertIntoOptions(_ values: [Option], at indexes: NSIndexSet)

    @objc(removeOptionsAtIndexes:)
    @NSManaged public func removeFromOptions(at indexes: NSIndexSet)

    @objc(replaceObjectInOptionsAtIndex:withObject:)
    @NSManaged public func replaceOptions(at idx: Int, with value: Option)

    @objc(replaceOptionsAtIndexes:withOptions:)
    @NSManaged public func replaceOptions(at indexes: NSIndexSet, with values: [Option])

    @objc(addOptionsObject:)
    @NSManaged public func addToOptions(_ value: Option)

    @objc(removeOptionsObject:)
    @NSManaged public func removeFromOptions(_ value: Option)

    @objc(addOptions:)
    @NSManaged public func addToOptions(_ values: NSOrderedSet)

    @objc(removeOptions:)
    @NSManaged public func removeFromOptions(_ values: NSOrderedSet)

}

extension StateQ : Identifiable {

}
