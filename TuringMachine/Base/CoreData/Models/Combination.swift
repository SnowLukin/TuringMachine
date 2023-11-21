//
//  Combination+CoreDataClass.swift
//  TuringMachine
//
//  Created by Snow Lukin on 20.11.2023.
//
//

import Foundation
import CoreData

@objc(Combination)
public class Combination: NSManagedObject {

}

extension Combination {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Combination> {
        return NSFetchRequest<Combination>(entityName: "Combination")
    }

    @NSManaged public var id: String?
    @NSManaged public var fromChar: String?
    @NSManaged public var toChar: String?
    @NSManaged public var directionIndex: Int64
    @NSManaged public var option: Option?

}

extension Combination : Identifiable {

}
