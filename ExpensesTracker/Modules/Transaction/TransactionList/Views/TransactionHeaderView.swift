//
//  TransactionHeaderView.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 02.09.2021.
//

import UIKit.UIView
import struct Domain.Bitcoin

protocol TransactionHeaderViewDelegate: AnyObject {
    func transactionHeaderView(_ view: TransactionHeaderView, didTapAddTransactionButton button: UIButton)
    func transactionHeaderView(_ view: TransactionHeaderView, didTapTopUpBalanceButton button: UIButton)
}

final class TransactionHeaderView: UIView {
    
    private enum C {
        enum Insets {
            static var containerView: UIEdgeInsets { UIEdgeInsets(top: 16, bottom: -16) }
            static var exchangeRateLabel: UIEdgeInsets { UIEdgeInsets(top: 16, trailing: -16) }
            static var balanceTitleLabel: UIEdgeInsets { UIEdgeInsets(top: 32, leading: 16) }
            static var balanceLabel: UIEdgeInsets { UIEdgeInsets(top: 8) }
            static var topUpBalanceButton: UIEdgeInsets { UIEdgeInsets(leading: 16, trailing: -16) }
            static var addTransactionButton: UIEdgeInsets{ UIEdgeInsets(top: 16, leading: 16, bottom: -16, trailing: -16) }
        }
        enum Size {
            static var containerView: CGSize { CGSize(width: UIScreen.main.bounds.width - 32, height: 200) }
            static var topUpBalanceButton: CGSize { CGSize(width: 50, height: 50) }
            static var addTransactionButton: CGSize { CGSize(width: UIScreen.main.bounds.width - 32, height: 50) }
        }
    }
    
    // MARK: - Properties
    private weak var delegate: TransactionHeaderViewDelegate?
    
    private let exchangeRateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30)
        label.textColor = .darkText
        label.text = Decimal().description
        return label
    }()
    
    private let balanceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .systemGray
        label.text = Localized("transactionList.header.label.balance")
        return label
    }()
    
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30)
        label.textColor = .systemGreen
        label.text = Decimal().description
        return label
    }()
    
    private lazy var addTransactionButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: C.Size.addTransactionButton))
        button.addTarget(self, action: #selector(didTapAddTransactionButton), for: .touchUpInside)
        button.setTitle(Localized("transactionList.header.button.addTransaction"), for: .normal)
        button.backgroundColor = .systemBlue
        button.cornerRadius = C.Size.addTransactionButton.height / 2
        return button
    }()
    
    private lazy var topUpBalanceButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: C.Size.topUpBalanceButton))
        button.setImage(UIImage(named: "icAddWhite"), for: .normal)
        button.addTarget(self, action: #selector(didTapTopUpBalanceButton), for: .touchUpInside)
        button.backgroundColor = .systemBlue
        button.cornerRadius = C.Size.topUpBalanceButton.height / 2
        return button
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.cornerRadius = 20
        return view
    }()
    
    
    // MARK: - Life Cycle
    init(delegate: TransactionHeaderViewDelegate, frame: CGRect) {
        self.delegate = delegate
        super.init(frame: frame)
        addSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateBalance(_ newBalance: Decimal) {
        balanceLabel.text = newBalance.description
    }
    
    func updateExchangeRate(_ bitcoin: Bitcoin) {
        exchangeRateLabel.text = bitcoin.fullDescription
    }
    
    // MARK: - Actions
    @objc private func didTapAddTransactionButton(_ button: UIButton) {
        delegate?.transactionHeaderView(self, didTapAddTransactionButton: button)

    }
    
    @objc private func didTapTopUpBalanceButton(_ button: UIButton) {
        delegate?.transactionHeaderView(self, didTapTopUpBalanceButton: button)
    }
    
    // MARK: - Setup
    private func setupSubviews(exchangeRate: Double, balance: Double) {
        balanceLabel.text = "\(balance)"
        exchangeRateLabel.text = "\(exchangeRate)"
        addSubviews()
    }
    
    private func addSubviews() {
        addSubview(containerView,
                   constraints: [containerView.topAnchor.constraint(equalTo: topAnchor,
                                                                    constant: C.Insets.containerView.top),
                                 containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
                                 containerView.widthAnchor.constraint(equalToConstant: C.Size.containerView.width),
                                 containerView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                                       constant: C.Insets.containerView.bottom)])
        
        containerView.addSubview(exchangeRateLabel,
                                 constraints:[exchangeRateLabel.topAnchor.constraint(equalTo: containerView.topAnchor,
                                                                                     constant: C.Insets.exchangeRateLabel.top),
                                              exchangeRateLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor,
                                                                                       constant: C.Insets.exchangeRateLabel.right)])

        containerView.addSubview(balanceTitleLabel,
                                 constraints: [balanceTitleLabel.topAnchor.constraint(equalTo: exchangeRateLabel.bottomAnchor,
                                                                                      constant: C.Insets.balanceTitleLabel.top),
                                               balanceTitleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor,
                                                                                       constant: C.Insets.balanceTitleLabel.left)])

        containerView.addSubview(balanceLabel,
                                 constraints: [balanceLabel.topAnchor.constraint(equalTo: balanceTitleLabel.bottomAnchor,
                                                                                 constant: C.Insets.balanceLabel.top),
                                               balanceLabel.leftAnchor.constraint(equalTo: balanceTitleLabel.leftAnchor)])

        containerView.addSubview(topUpBalanceButton,
                                 constraints: [topUpBalanceButton.heightAnchor.constraint(equalToConstant: C.Size.topUpBalanceButton.height),
                                               topUpBalanceButton.widthAnchor.constraint(equalToConstant: C.Size.topUpBalanceButton.width),
                                               topUpBalanceButton.leftAnchor.constraint(equalTo: balanceLabel.rightAnchor,
                                                                                        constant: C.Insets.topUpBalanceButton.left),
                                               topUpBalanceButton.rightAnchor.constraint(equalTo: containerView.rightAnchor,
                                                                                         constant: C.Insets.topUpBalanceButton.right),
                                               topUpBalanceButton.bottomAnchor.constraint(equalTo: balanceLabel.bottomAnchor)])
        
        containerView.addSubview(addTransactionButton,
                                 constraints: [addTransactionButton.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor,
                                                                                         constant: C.Insets.addTransactionButton.top),
                                               addTransactionButton.leftAnchor.constraint(equalTo: containerView.leftAnchor,
                                                                                          constant: C.Insets.addTransactionButton.left),
                                               addTransactionButton.rightAnchor.constraint(equalTo: containerView.rightAnchor,
                                                                                           constant: C.Insets.addTransactionButton.right),
                                               addTransactionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                                                                            constant: C.Insets.addTransactionButton.bottom),
                                               addTransactionButton.heightAnchor.constraint(equalToConstant: C.Size.addTransactionButton.height)])
    }
}
