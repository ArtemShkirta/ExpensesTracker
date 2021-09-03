//
//  AppDelegate.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 02.09.2021.
//

import UIKit
import protocol Domain.UseCasesProvider
import protocol Domain.TransactionUseCase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    var window: UIWindow?
    private lazy var appCoordinator = AppCoordinator(useCases: self)
    
    // MARK: - Life Cycle
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        appCoordinator.start(animated: false)
        window = appCoordinator.window
        return true
    }
}

extension AppDelegate: UseCasesProvider, TransactionUseCase {
    var transaction: TransactionUseCase {
        self
    }
}
