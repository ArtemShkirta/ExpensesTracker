//
//  NSManagedObjectContext+Save.swift
//  Platform
//
//  Created by Artem Shkirta on 04.09.2021.
//

import CoreData.NSManagedObjectContext

extension NSManagedObjectContext {
    func saveIfNeeded() throws {
        guard hasChanges else { return }
        try save()
    }
}
