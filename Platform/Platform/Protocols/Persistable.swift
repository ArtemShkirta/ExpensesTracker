//
//  Persistable.swift
//  Platform
//
//  Created by Artem Shkirta on 04.09.2021.
//

import CoreData

public protocol Persistable {
    associatedtype Object: NSManagedObject

    func update(_ object: Object, in context: NSManagedObjectContext) throws
}
