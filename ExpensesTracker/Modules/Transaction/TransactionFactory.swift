//
//  TransactionFactory.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 02.09.2021.
//

import UIKit

protocol TransactionFactoryProtocol {
    func makeTransactionListVC(delegate: TransactionListVCDelegate) -> TransactionListVC
    func makeExpensesVC(delegate: ExpensesVCDelegate) -> ExpensesVC
    func makeErrorAlertVC(error: Error) -> UIAlertController
    func makeTopUpBalanceAlert(delegate: UITextFieldDelegate,
                               okayHandler: ((String) -> Void)?,
                               cancelHandler: (() -> Void)?) -> UIAlertController
}

final class TransactionFactory: ModuleFactory, TransactionFactoryProtocol {
    func makeTransactionListVC(delegate: TransactionListVCDelegate) -> TransactionListVC {
        makeController { contoller in
            contoller.delegate =  delegate
        }
    }
    
    func makeExpensesVC(delegate: ExpensesVCDelegate) -> ExpensesVC {
        makeController { contoller in
            contoller.delegate = delegate
        }
    }
    
    func makeTopUpBalanceAlert(delegate: UITextFieldDelegate, okayHandler: ((String) -> Void)?, cancelHandler: (() -> Void)?) -> UIAlertController {
        let controller = UIAlertController(title: LocalizedAlert("topUpBalance.title"), message: LocalizedAlert("topUpBalance.message"), preferredStyle: .alert)
        controller.addTextField { textField in
            textField.delegate = delegate
            textField.keyboardType = .decimalPad
            textField.placeholder = LocalizedAlert("topUpBalance.placeholder")
        }
        controller.addAction(.okay { [weak controller] _ in
            controller?.textFields?.first?.text.flatMap {
                okayHandler?($0)
            }
        })
        controller.addAction(.cancel { _ in cancelHandler?() })
        return controller
    }
    
    func makeErrorAlertVC(error: Error) -> UIAlertController {
        let alert = UIAlertController(title: LocalizedAlert("title.error"), message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(.okay())
        return alert
    }
}
