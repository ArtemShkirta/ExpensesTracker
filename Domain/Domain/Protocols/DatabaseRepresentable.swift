//
//  DatabaseRepresentable.swift
//  Platform
//
//  Created by Artem Shkirta on 04.09.2021.
//

import CoreData

public protocol DatabaseRepresentable {
    associatedtype Object
    
    init(_ object: Object) throws
}
