//
//  CDDataSource.swift
//  Platform
//
//  Created by Artem Shkirta on 04.09.2021.
//

import CoreData
import protocol Domain.DatabaseRepresentable
import protocol Domain.DataSource

struct CDDataSource<Object, ManagedObject: NSFetchRequestResult> {
    
    typealias Mapper = (ManagedObject) throws -> Object
    typealias Object = Object
    
    private let fetchedResultsController: NSFetchedResultsController<ManagedObject>
    private let mapper: Mapper
    
    init(fetchRequest: NSFetchRequest<ManagedObject>,
         context: NSManagedObjectContext,
         mapper: @escaping Mapper,
         sectionNameKeyPath: String? = nil,
         cacheName name: String? = nil,
         delegate: NSFetchedResultsControllerDelegate? = nil) {
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: context,
                                                              sectionNameKeyPath: sectionNameKeyPath,
                                                              cacheName: name)
        fetchedResultsController.delegate = delegate
        self.mapper = mapper
    }
}

// MARK: - DataSource
extension CDDataSource: DataSource {
    var numberOfSections: Int {
        fetchedResultsController.sections?.count ?? 0
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        fetchedResultsController.sections?[section].objects?.count ?? 0
    }
    
    func performFetch() throws {
        try fetchedResultsController.performFetch()
    }
    
    func object(at indexPath: IndexPath) throws -> Object {
        try mapper(fetchedResultsController.object(at: indexPath))
    }
    
    func sectionName(ofSection section: Int) -> String? {
        fetchedResultsController.sections?[section].name
    }
}
