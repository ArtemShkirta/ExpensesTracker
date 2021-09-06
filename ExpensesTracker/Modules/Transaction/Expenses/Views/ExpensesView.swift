//
//  ExpensesView.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 05.09.2021.
//

import UIKit

protocol ExpensesViewDelegate: AnyObject {
    func expensesView(_ view: ExpensesView, didTapAddButton button: UIButton)
}

final class ExpensesView: UIView {
    
    typealias Delegate = ExpensesViewDelegate & UIPickerViewDelegate & UIPickerViewDataSource & UITextFieldDelegate
    
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
    
    // MARK: - Public Properties
    var prise: Decimal? {
        priceTextField.text.flatMap { Double($0) }.flatMap { Decimal($0) }
    }
    
    var sort: String? {
        sortTextField.text
    }
    
    // MARK: - Private Properties
    private weak var delegate: Delegate?
    
    private let priceTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
    
        textField.placeholder = Localized("expenses.textField.price.placeholder")
        return textField
    }()
    
    private lazy var sortTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.inputView = pickerView
        textField.tintColor = .clear
        textField.placeholder = Localized("expenses.textField.sort.placeholder")
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
    
    private let pickerView: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    // MARK: - Life Cycle
    init(delegate: Delegate, frame: CGRect) {
        super.init(frame: frame)
        self.delegate = delegate
        pickerView.dataSource = delegate
        pickerView.delegate = delegate
        priceTextField.delegate = delegate
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
    
    // MARK: - Update
    func updateSort(_ newSort: String) {
        sortTextField.text = newSort
    }
}
