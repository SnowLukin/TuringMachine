//
//  Option+CoreDataClass.swift
//  TuringMachine
//
//  Created by Snow Lukin on 20.11.2023.
//
//

import Foundation
import CoreData

@objc(Option)
public class Option: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Option> {
        return NSFetchRequest<Option>(entityName: "Option")
    }

    @NSManaged public var id: String?
    @NSManaged public var toStateId: String?
    @NSManaged public var state: StateQ?
    @NSManaged public var combinations: NSOrderedSet?
    
    public var unwrappedCombinations: [Combination] {
        guard let combinations else { return [] }
        return combinations.compactMap { $0 as? Combination }
    }
}

// MARK: Generated accessors for combinations
extension Option {

    @objc(insertObject:inCombinationsAtIndex:)
    @NSManaged public func insertIntoCombinations(_ value: Combination, at idx: Int)

    @objc(removeObjectFromCombinationsAtIndex:)
    @NSManaged public func removeFromCombinations(at idx: Int)

    @objc(insertCombinations:atIndexes:)
    @NSManaged public func insertIntoCombinations(_ values: [Combination], at indexes: NSIndexSet)

    @objc(removeCombinationsAtIndexes:)
    @NSManaged public func removeFromCombinations(at indexes: NSIndexSet)

    @objc(replaceObjectInCombinationsAtIndex:withObject:)
    @NSManaged public func replaceCombinations(at idx: Int, with value: Combination)

    @objc(replaceCombinationsAtIndexes:withCombinations:)
    @NSManaged public func replaceCombinations(at indexes: NSIndexSet, with values: [Combination])

    @objc(addCombinationsObject:)
    @NSManaged public func addToCombinations(_ value: Combination)

    @objc(removeCombinationsObject:)
    @NSManaged public func removeFromCombinations(_ value: Combination)

    @objc(addCombinations:)
    @NSManaged public func addToCombinations(_ values: NSOrderedSet)

    @objc(removeCombinations:)
    @NSManaged public func removeFromCombinations(_ values: NSOrderedSet)

}

extension Option : Identifiable {

}
