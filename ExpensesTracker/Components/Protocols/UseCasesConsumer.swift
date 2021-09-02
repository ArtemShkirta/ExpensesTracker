//
//  UseCasesConsumer.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 02.09.2021.
//

import Foundation

protocol UseCasesConsumer: AnyObject {
    associatedtype UseCases
    
    var useCases: UseCases { get }
}

private enum UseCasesConsumerKeys {
    static var useCases = "useCases"
}

extension UseCasesConsumer {
    var useCases: UseCases {
        get {
            if let useCases: UseCases = ObjcRuntime.getAssociatedObject(
                object: self,
                key: &UseCasesConsumerKeys.useCases) {
                return useCases
            } else { fatalError("useCases are required for \(Self.self)") }
        }
        
        set {
            ObjcRuntime.setAssociatedObject(object: self,
                                            value: newValue,
                                            key: &UseCasesConsumerKeys.useCases,
                                            policy: .retain)
        }
    }
}

