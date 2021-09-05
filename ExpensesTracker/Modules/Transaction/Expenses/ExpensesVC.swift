//
//  ExpensesVC.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 05.09.2021.
//

import UIKit
import protocol Domain.HasTransactionUseCase

protocol ExpensesVCDelegate: AnyObject {
    func expensesVC(_ controller: ExpensesVC, didTapAddButton button: UIButton)
}

final class ExpensesVC: UIViewController, UseCasesConsumer {
    
    typealias UseCases = HasTransactionUseCase
    
    // MARK: - Public Properties
    weak var delegate: ExpensesVCDelegate?
    
    // MARK: - Private Properties
    private lazy var expensesView: ExpensesView = {
        let view = ExpensesView(delegate: self, frame: UIScreen.main.bounds)
        view.backgroundColor = .systemGray6
        view.addHideKeyboardGesture()
        return view
    }()
    
    // MARK: - Life Cycle
    override func loadView() {
        view = expensesView
    }
}

// MARK: - Makeable
extension ExpensesVC: Makeable {
    static func make() -> ExpensesVC {
        ExpensesVC()
    }
}

// MARK: - ExpensesViewDelegate
extension ExpensesVC: ExpensesViewDelegate {
    func expensesView(_ view: ExpensesView, didTapAddButton button: UIButton) {
        print("didTapAddButton")
        delegate?.expensesVC(self, didTapAddButton: button)
    }
}
