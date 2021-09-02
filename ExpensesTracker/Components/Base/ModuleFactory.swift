//
//  ModuleFactory.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 02.09.2021.
//

import UIKit.UIViewController
import protocol Domain.UseCasesProvider

class ModuleFactory {
    private(set) weak var coordinator: Coordinator?
    let useCases: UseCasesProvider
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        self.useCases = coordinator.useCases
    }
}

extension ModuleFactory {
    func makeController<T: Makeable>(_ builder: T.Builder) -> T where T.Value == T, T: UIViewController {
        let controller: T = T.make(builder)
        coordinator.flatMap(controller.setCoordinator)
        return controller
    }
    
    func makeController<T: UIViewController & Makeable & UseCasesConsumer>(_ builder: T.Builder) -> T where T.Value == T {
        guard let useCases = useCases as? T.UseCases else {
            fatalError("T.UseCases should be subset of Coordinator.UseCasesProvider")
        }
        let controller: T = T.make {
            $0.useCases = useCases
            builder(&$0)
        }
        coordinator.flatMap(controller.setCoordinator)
        return controller
    }
}

private enum UIViewControllerKeys {
    static var coordinator = "coordinator"
}

extension UIViewController {
    func setCoordinator(_ coordinator: Coordinator) {
        setAssociatedObject(value: coordinator,
                            key: UIViewControllerKeys.coordinator,
                            policy: .retainNonatomic)
    }
}
