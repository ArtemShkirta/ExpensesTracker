//
//  TransactionFactory.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 02.09.2021.
//

import Foundation

protocol TransactionFactoryProtocol {
    func makeTransactionListVC() -> TransactionListVC
}

final class TransactionFactory: ModuleFactory, TransactionFactoryProtocol {
    func makeTransactionListVC() -> TransactionListVC {
        makeController { _ in
            
        }
    }
}
