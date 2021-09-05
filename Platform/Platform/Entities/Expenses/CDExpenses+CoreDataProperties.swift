//
//  CDExpenses+CoreDataProperties.swift
//  
//
//  Created by Artem Shkirta on 03.09.2021.
//
//

import Foundation
import CoreData

extension CDExpenses {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDExpenses> {
        return NSFetchRequest<CDExpenses>(entityName: "CDExpenses")
    }

    @NSManaged public var sort: Int16

}
