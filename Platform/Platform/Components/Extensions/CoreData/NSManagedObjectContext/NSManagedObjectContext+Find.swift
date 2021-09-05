//
//  NSManagedObjectContext+Find.swift
//  Platform
//
//  Created by Artem Shkirta on 05.09.2021.
//

import Foundation

import CoreData

extension NSManagedObjectContext {
    public enum Function: String {
        case average
        case sum
        case min
        case max
    }
    
    func find<Root: NSManagedObject, Value: AttributeTypeConvertible>(_ function: Function,
                                                                      of keyPath: KeyPath<Root, Value>) throws -> Value {
        let fetchRequest = makeFindFetchRequest(function: function,
                                                argument: NSExpression(forKeyPath: keyPath),
                                                entity: Root.entity(),
                                                attributeType: Value.attributeType)
        return try (fetch(fetchRequest).last?["result"] as? Value).orThrow(DatabaseError.cantExecute)
    }
    
    func find<Root: NSManagedObject, Value: AttributeTypeConvertible>(_ function: Function,
                                                                      of keyPath: KeyPath<Root, Value?>) throws -> Value {
        let fetchRequest = makeFindFetchRequest(function: function,
                                                argument: NSExpression(forKeyPath: keyPath),
                                                entity: Root.entity(),
                                                attributeType: Value.attributeType)
        return try (fetch(fetchRequest).last?["result"] as? Value).orThrow(DatabaseError.cantExecute)
    }
    
    private func makeFindFetchRequest(function: Function,
                                      argument: NSExpression,
                                      entity: NSEntityDescription,
                                      attributeType: NSAttributeType) -> NSFetchRequest<NSDictionary> {
        let description = NSExpressionDescription()
        description.name = "result"
        description.expression = NSExpression(forFunction: "\(function.rawValue):", arguments: [argument])
        description.expressionResultType = attributeType
        let fetchRequest = NSFetchRequest<NSDictionary>()
        fetchRequest.entity = entity
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = [description]
        return fetchRequest
    }
}
