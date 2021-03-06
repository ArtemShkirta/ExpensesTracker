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
        let transactionListVC = factory.makeTransactionListVC(delegate: self)
        presenter.pushViewController(transactionListVC, animated: animated)
    }
}

// MARK: - TransactionListVCDelegate
extension TransactionCoordinator: TransactionListVCDelegate {
    func transactionListVCShowTopUpBalanceAlert(_ controller: TransactionListVC, callback: Command<String>) {
        let alertController = factory.makeTopUpBalanceAlert(delegate: controller,
                                                            okayHandler: { [weak presenter] value in
                                                                callback.perform(value: value)
                                                                presenter?.dismiss(animated: true)
                                                            }, cancelHandler: { [weak presenter] in
                                                                presenter?.dismiss(animated: true)
                                                            })
        presenter.present(alertController, animated: true)
    }
    
    func transactionListVC(_ controller: TransactionListVC, didTapAddTransactionButton button: UIButton) {
        let expensesVC = factory.makeExpensesVC(delegate: self)
        presenter.pushViewController(expensesVC, animated: true)
    }
    
    func transactionListVC(_ controller: TransactionListVC, shouldShowError error: Error) {
        let alertVC = factory.makeErrorAlertVC(error: error)
        controller.present(alertVC, animated: true)
    }
}

// MARK: - ExpensesVCDelegate
extension TransactionCoordinator: ExpensesVCDelegate {
    func expensesVC(_ controller: ExpensesVC, didTapAddButton button: UIButton) {
        presenter.popViewController(animated: true)
    }
    
    func expensesVC(_ controller: ExpensesVC, shouldShowError error: Error) {
        let alertVC = factory.makeErrorAlertVC(error: error)
        controller.present(alertVC, animated: true)
    }
}
