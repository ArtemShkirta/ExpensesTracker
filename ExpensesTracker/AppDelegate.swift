//
//  AppDelegate.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 02.09.2021.
//

import UIKit
import protocol Domain.UseCasesProvider
import protocol Domain.TransactionUseCase
import class Platform.Platform

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    var window: UIWindow?
    private lazy var appCoordinator = AppCoordinator(useCases: platform)
    private let platform = Platform()
    
    // MARK: - Life Cycle
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        appCoordinator.start(animated: false)
        window = appCoordinator.window
        return true
    }
}
