//
//  CDDatabase.swift
//  Platform
//
//  Created by Artem Shkirta on 04.09.2021.
//

import CoreData
import protocol Domain.Persistable

public final class CDDatabase {
    
    public enum Context {
        /// The managed object context associated with the main queue.
        case main
        /// The managed object context associated with the private queue.
        case background
        /// The managed object context associated with the current thread.
        case current
    }

    // MARK: - Private Properties
    
    /*
     The persistent container or the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it.
     */
    private let persistentContainer: NSPersistentContainer
    
    /// The managed object context associated with the main queue.
    public let mainContext: NSManagedObjectContext
    /// The managed object context associated with the private queue.
    private let backgroundContext: NSManagedObjectContext
    
    // MARK: - Lifecycle
    public init(containerName: String = "Model") {
        guard let modelURL = Bundle(for: type(of: self)).url(forResource: containerName, withExtension: "momd"),
              let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError()
        }
        persistentContainer = NSPersistentContainer(name: containerName, managedObjectModel: managedObjectModel)
        persistentContainer.loadPersistentStores { _, error in
            guard let error = error as NSError? else { return }
            fatalError("LoadPersistentStores: Unresolved error \(error), \(error.userInfo)")
        }
        
        mainContext = persistentContainer.viewContext
        mainContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleDidSaveNotification),
                                               name: .NSManagedObjectContextDidSave,
                                               object: nil)
    }
    
    // MARK: - Helper Methods
    @objc private func handleDidSaveNotification(_ notification: Notification) {
        mainContext.mergeChanges(fromContextDidSave: notification)
    }
}

// MARK: - Perform
extension CDDatabase {
    private func perform<T>(in context: Context,
                            action: @escaping (NSManagedObjectContext) throws -> T,
                            completion: @escaping (Result<T, DatabaseError>) -> Void) {
        let managedObjectContext = managedObjectContext(for: context)
        managedObjectContext.perform { [weak managedObjectContext] in
            guard let context = managedObjectContext else { return }
            do {
                completion(.success(try action(context)))
            } catch {
                completion(.failure(.underlying(error)))
            }
        }
    }
    
    private func performAndWait<T>(in context: Context,
                                   action: (NSManagedObjectContext) throws -> T) -> Result<T, DatabaseError> {
        var result = Result<T, DatabaseError>.failure(.cantExecute)
        let managedObjectContext = managedObjectContext(for: context)
        managedObjectContext.performAndWait {
            do {
                result = .success(try action(managedObjectContext))
            } catch {
                result = .failure(.underlying(error))
            }
        }
        return result
    }
    
    private func managedObjectContext(for context: Context) -> NSManagedObjectContext {
        switch context {
        case .main:
            return mainContext
        case .background:
            return backgroundContext
        case .current:
            return Thread.isMainThread ? mainContext : backgroundContext
        }
    }
}

// MARK: - Save
public extension CDDatabase {
    /// Use this method to save value as Persistable.Object in database.
    ///
    /// - Note: This method will save value as Persistable.Object in store and notify main context about changes.
    ///
    /// - Parameter value: Stored value.
    /// - Parameter context: The context in which the changes should be save.
    /// - Parameter completion: Result of saving.
    func save<T: Persistable>(_ value: T,
                              in context: Context = .background,
                              completion: @escaping (Result<T, DatabaseError>) -> Void) {
        perform(in: context, action: { context in
            let object = T.Object(entity: T.Object.entity(), insertInto: context)
            try value.update(object, in: context)
            try context.saveIfNeeded()
        }, completion: { result in
            completion(result.map { _ in value })
        })
    }
}
