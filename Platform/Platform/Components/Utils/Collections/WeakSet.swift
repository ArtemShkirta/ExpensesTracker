//
//  WeakSet.swift
//  Platform
//
//  Created by Artem Shkirta on 05.09.2021.
//

import Foundation

struct WeakSetIterator<IterationObject>: IteratorProtocol {
    
    // MARK: - Properties
    var objects: [IterationObject]?
    
    // MARK: - Private Properties
    private var currentIndex: Int = 0
    
    // MARK: - Life Cycle
    init(objects: [AnyObject]) {
        self.objects = objects as? [IterationObject]
    }
    
    mutating func next() -> IterationObject? {
        guard let objects = objects else {
            return nil
        }
        
        if currentIndex < objects.count {
            let object = objects[currentIndex]
            currentIndex += 1
            
            return object
        }
        
        return nil
    }
}

/**
 A collection that not retains the object. Uses the NSHashTable under the hood to store objects weakly.
 */
class WeakSet<Object>: Sequence {
    
    // MARK: - Computed Properties
    var count: Int {
        return weakStorage.count
    }
    
    var isEmpty: Bool {
        return weakStorage.count == 0
    }
    
    var allObjects: [Object] {
        guard let allWeakObjects = weakStorage.allObjects as? [Object] else {
            return []
        }
        
        return allWeakObjects
    }
    
    // MARK: - Private Properties
    private let weakStorage = NSHashTable<AnyObject>.weakObjects()
    
    // MARK: - Life Cycle
    init(arrayLiteral elements: Object...) {
        for case let element as AnyObject in elements {
            weakStorage.add(element)
        }
    }
    
    // MARK: - Operations
    func append(_ object: Object) {
        weakStorage.add(object as AnyObject)
    }
    
    func append(contentsOf objects: [Object]) {
        objects.forEach { append($0) }
    }
    
    func remove(_ object: Object) {
        weakStorage.remove(object as AnyObject)
    }
    
    func removeAll() {
        weakStorage.removeAllObjects()
    }
    
    func contains(_ object: Object) -> Bool {
        return weakStorage.contains(object as AnyObject)
    }
    
    // MARK: - Sequence
    func makeIterator() -> WeakSetIterator<Object> {
        return WeakSetIterator(objects: weakStorage.allObjects)
    }
}

