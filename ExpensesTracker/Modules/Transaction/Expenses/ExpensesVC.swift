//
//  ExpensesVC.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 05.09.2021.
//

import UIKit
import Domain

protocol ExpensesVCDelegate: AnyObject {
    func expensesVC(_ controller: ExpensesVC, didTapAddButton button: UIButton)
    func expensesVC(_ controller: ExpensesVC, shouldShowError error: Error)
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
    
    // MARK: - Helper Methods
    private func showError(_ error: Error) {
        delegate?.expensesVC(self, shouldShowError: error)
    }
    
    private func handleSaveResult(_ result: Result<Expenses, AppError>, addButton: UIButton) {
        switch result {
        case .success:
            delegate?.expensesVC(self, didTapAddButton: addButton)
        case .failure(let error):
            showError(error)
        }
    }
}

// MARK: - Makeable
extension ExpensesVC: Makeable {
    static func make() -> ExpensesVC {
        ExpensesVC()
    }
}

// MARK: - UIPickerViewDataSource
extension ExpensesVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        Expenses.Sort.allCases.count
    }
}

// MARK: - UIPickerViewDelegate
extension ExpensesVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        Expenses.Sort.allCases[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        expensesView.updateSort(Expenses.Sort.allCases[row].name)
    }
}

// MARK: - UITextFieldDelegate
extension ExpensesVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        PriceTextProcessor(max: 10).shouldReplaceCharacters(in: range, replacement: string, textInput: textField)
    }
}


// MARK: - ExpensesViewDelegate
extension ExpensesVC: ExpensesViewDelegate {
    func expensesView(_ view: ExpensesView, didTapAddButton button: UIButton) {
        guard let price = expensesView.prise else {
            return showError(AppError.validation(.priceEmpty))
        }
        guard let sort = expensesView.sort, let expensesSort = Expenses.Sort(name: sort) else {
            return showError(AppError.validation(.sortEmpty))
        }
        useCases.transaction.save(transaction: Expenses(price: Price(value: -price), sort: expensesSort)) { [weak self] result in
            DispatchQueue.main.async {
                self?.handleSaveResult(result, addButton: button)
            }
        }
    }
}
