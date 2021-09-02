//
//  TransactionCoordinator.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 02.09.2021.
//

import UIKit
import protocol Domain.UseCasesProvider

final class TransactionCoordinator: Coordinator {
    
    // MARK: - Public Properties
    let useCases: UseCasesProvider
    
    // MARK: - Private Properties
    private unowned let presenter: UINavigationController
    private lazy var factory: TransactionFactoryProtocol = TransactionFactory(coordinator: self)
    
    // MARK: - Life Cycle
    init(presenter: UINavigationController, useCases: UseCasesProvider) {
        self.presenter = presenter
        self.useCases = useCases
    }
    
    func start(animated: Bool) {
        let transactionListVC = factory.makeTransactionListVC()
        presenter.pushViewController(transactionListVC, animated: animated)
    }
}
