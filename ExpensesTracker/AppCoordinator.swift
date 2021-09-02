//
//  AppCoordinator.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 02.09.2021.
//

import UIKit
import protocol Domain.UseCasesProvider

final class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    let window: UIWindow
    let useCases: UseCasesProvider
    
    // MARK: - Lifecycle
    init(useCases: UseCasesProvider, window: UIWindow = UIWindow(frame: UIScreen.main.bounds)) {
        self.window = window
        self.useCases = useCases
    }
    
    func start(animated: Bool) {
        let presenter = UINavigationController()
        window.rootViewController = presenter
        
        window.makeKeyAndVisible()
    }
}
