//
//  Persistable.swift
//  Domain
//
//  Created by Artem Shkirta on 05.09.2021.
//

import CoreData

public protocol Persistable {
    associatedtype Object: NSManagedObject

    func update(_ object: Object, in context: NSManagedObjectContext) throws
}
