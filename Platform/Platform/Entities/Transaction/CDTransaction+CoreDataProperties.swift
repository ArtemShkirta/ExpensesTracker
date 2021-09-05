//
//  CDTransaction+CoreDataProperties.swift
//  
//
//  Created by Artem Shkirta on 03.09.2021.
//
//

import Foundation
import CoreData

extension CDTransaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTransaction> {
        return NSFetchRequest<CDTransaction>(entityName: "CDTransaction")
    }

    @NSManaged public var createDate: Date
    @NSManaged public var price: NSDecimalNumber
    @NSManaged public var currency: Int16
    @NSManaged public var kind: Int16

}
