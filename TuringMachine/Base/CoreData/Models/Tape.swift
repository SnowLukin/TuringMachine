//
//  Tape+CoreDataClass.swift
//  TuringMachine
//
//  Created by Snow Lukin on 20.11.2023.
//
//

import Foundation
import CoreData

@objc(Tape)
public class Tape: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tape> {
        return NSFetchRequest<Tape>(entityName: "Tape")
    }

    @NSManaged public var id: String?
    @NSManaged public var createdDate: Date?
    @NSManaged public var headIndex: Int64
    @NSManaged public var input: String?
    @NSManaged public var algorithm: Algorithm?
}

extension Tape : Identifiable {

}
