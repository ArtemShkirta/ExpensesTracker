//
//  AnyDataSource.swift
//  Domain
//
//  Created by Artem Shkirta on 04.09.2021.
//

public struct AnyDataSource<Object> {
    
    // MARK: - Properties
    private let objectAtIndexClosure: (IndexPath) throws -> Object
    private let numberOfSectionsClosure: () -> Int
    private let numberOfRowsInSectionClosure: (Int) -> Int
    private let performFetchClosure: () throws -> Void
    private let sectionNameOfSectionClosure: (Int) -> String?
    
    // MARK: - Life Cycle
    public init<T: DataSource>(_ dataSource: T) where T.Object == Object {
        objectAtIndexClosure = dataSource.object(at:)
        numberOfSectionsClosure = { dataSource.numberOfSections }
        numberOfRowsInSectionClosure = dataSource.numberOfRows(inSection:)
        performFetchClosure = dataSource.performFetch
        sectionNameOfSectionClosure = dataSource.sectionName(ofSection:)
    }
}

// MARK: - DataSource
extension AnyDataSource: DataSource {
    public var numberOfSections: Int {
        numberOfSectionsClosure()
    }
    
    public func numberOfRows(inSection section: Int) -> Int {
        numberOfRowsInSectionClosure(section)
    }
    
    public func performFetch() throws {
        try performFetchClosure()
    }
    
    public func object(at indexPath: IndexPath) throws -> Object {
        try objectAtIndexClosure(indexPath)
    }
    
    public func sectionName(ofSection section: Int) -> String? {
        sectionNameOfSectionClosure(section)
    }
}
