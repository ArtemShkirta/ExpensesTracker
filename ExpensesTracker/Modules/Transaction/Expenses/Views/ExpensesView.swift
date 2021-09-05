//
//  ExpensesView.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 05.09.2021.
//

import UIKit
import class Domain.Expenses

protocol ExpensesViewDelegate: AnyObject {
    func expensesView(_ view: ExpensesView, didTapAddButton button: UIButton)
}

final class ExpensesView: UIView {
    
    private enum C {
        enum Insets {
            static var priceTextField: UIEdgeInsets { UIEdgeInsets(top: 32, leading: 16, trailing: -16) }
            static var sortTextField: UIEdgeInsets { UIEdgeInsets(top: 16, leading: 16, trailing: -16) }
            static var addExpensesButton: UIEdgeInsets { UIEdgeInsets(top: 32) }
        }
        enum Size {
            static var addExpensesButton: CGSize { CGSize(width: 200, height: 50) }
        }
    }
    
    // MARK: - Private Properties
    private weak var delegate: ExpensesViewDelegate?
    
    private let priceTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private lazy var sortTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.inputView = pickerView
        return textField
    }()
    
    private lazy var addExpensesButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: C.Size.addExpensesButton))
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        button.setTitle(Localized("expenses.button.add"), for: .normal)
        button.backgroundColor = .systemBlue
        button.cornerRadius = C.Size.addExpensesButton.height / 2
        return button
    }()
    
    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    
    // MARK: - Life Cycle
    init(delegate: ExpensesViewDelegate, frame: CGRect) {
        super.init(frame: frame)
        self.delegate = delegate
        setupSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func didTapAddButton(_ button: UIButton) {
        delegate?.expensesView(self, didTapAddButton: button)
    }
    
    // MARK: - Setup
    private func setupSubviews() {
        addSubview(priceTextField,
                   constraints: [priceTextField.topAnchor.constraint(equalTo: topAnchor, constant: C.Insets.priceTextField.top),
                                 priceTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: C.Insets.priceTextField.left),
                                 priceTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: C.Insets.priceTextField.right)])
        
        addSubview(sortTextField,
                   constraints: [sortTextField.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: C.Insets.sortTextField.top),
                                 sortTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: C.Insets.sortTextField.left),
                                 sortTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: C.Insets.sortTextField.right)])
        
        addSubview(addExpensesButton,
                   constraints: [addExpensesButton.topAnchor.constraint(equalTo: sortTextField.bottomAnchor, constant: C.Insets.addExpensesButton.top),
                                 addExpensesButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                                 addExpensesButton.widthAnchor.constraint(equalToConstant: C.Size.addExpensesButton.width),
                                 addExpensesButton.heightAnchor.constraint(equalToConstant: C.Size.addExpensesButton.height)])
    }
}

// MARK: - UIPickerViewDataSource
extension ExpensesView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        Expenses.Sort.allCases.count
    }
}

// MARK: - UIPickerViewDelegate
extension ExpensesView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        Expenses.Sort.allCases[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sortTextField.text = Expenses.Sort.allCases[row].name
    }
}
