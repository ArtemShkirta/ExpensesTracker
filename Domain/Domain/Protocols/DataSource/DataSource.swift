//
//  DataSource.swift
//  Platform
//
//  Created by Artem Shkirta on 04.09.2021.
//

public protocol DataSource {
    associatedtype Object
    
    var numberOfSections: Int { get }
    
    func numberOfRows(inSection section: Int) -> Int
    func performFetch() throws
    func object(at indexPath: IndexPath) throws -> Object
    func sectionTitle(for section: Int) -> String?
}
