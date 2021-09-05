//
//  TransactionSpendingTVC.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 03.09.2021.
//

import UIKit.UITableViewCell
import struct Domain.Price
import class Domain.Expenses

final class TransactionSpendingTVC: UITableViewCell {
    private enum C {
        enum Insets {
            static var titleLabel: UIEdgeInsets { UIEdgeInsets(top: 16, leading: 16) }
            static var dateLabel: UIEdgeInsets { UIEdgeInsets(top: 8, leading: 16, bottom: -16) }
            static var amountLabel: UIEdgeInsets { UIEdgeInsets(leading: 16, trailing: -16) }
        }
    }
    
    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .systemGray
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Config
    func config(sort: Expenses.Sort, price: Price, date: Date) {
        titleLabel.text = sort.name
        amountLabel.text = "-\(price.displayFull)"
        dateLabel.text = DateFormatter.transaction.string(from: date)
    }
    
    // MARK: - Setup
    private func setupUI() {
        addSubview(titleLabel,
                   constraints: [titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: C.Insets.titleLabel.top),
                                 titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: C.Insets.titleLabel.left)])
        
        addSubview(dateLabel,
                   constraints: [dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: C.Insets.dateLabel.top),
                                 dateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: C.Insets.dateLabel.left),
                                 dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: C.Insets.dateLabel.bottom)])
        
        addSubview(amountLabel,
                   constraints: [amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                                 amountLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: C.Insets.amountLabel.right),
                                 amountLabel.leftAnchor.constraint(greaterThanOrEqualTo: titleLabel.rightAnchor, constant: C.Insets.amountLabel.left)])
    }
}
