//
//  Coordinator.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 02.09.2021.
//

import protocol Domain.UseCasesProvider

protocol Coordinator: AnyObject {
    var useCases: UseCasesProvider { get }
    
    func start(animated: Bool)
    func stop(animated: Bool)
}

extension Coordinator {
    func start() {
        start(animated: true)
    }
    
    func stop(animated: Bool = true) { }
}
