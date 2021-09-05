//
//  TransactionListVC.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 02.09.2021.
//

import UIKit
import Domain

final class TransactionListVC: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.setAndLayoutTableHeaderView(header: headerView)
//        tableView.tableHeaderView = headerView
        tableView.tableHeaderView?.layoutIfNeeded()
        tableView.tableHeaderView?.sizeToFit()
        tableView.tableHeaderView?.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        tableView.register(TransactionSpendingTVC.self, TransactionIncomeTVC.self)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = .zero
        return tableView
    }()
    
    private lazy var headerView: TransactionHeaderView = {
        let headerView = TransactionHeaderView(exchangeRate: 35.6, balance: 12121323.0, delegate: self, frame: UIScreen.main.bounds)
        return headerView
    }()
    
    override func loadView() {
        view = tableView
    }
}

// MARK: - Makeable
extension TransactionListVC: Makeable {
    static func make() -> TransactionListVC {
        TransactionListVC()
    }
}

// MARK: - UITableViewDataSource
extension TransactionListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            return tableView.makeCell(TransactionSpendingTVC.self) {
                $0.config(sort: .electronics, price: Price(value: 12.9, currency: .bitcoin), date: .distantFuture)
            }
        } else {
            return tableView.makeCell(TransactionIncomeTVC.self) {
                $0.config(price: Price(value: 400, currency: .bitcoin), date: .distantPast)
            }
        }
    }
}

// MARK: - TransactionHeaderViewDelegate {
extension TransactionListVC: TransactionHeaderViewDelegate {
    func transactionHeaderView(_ view: TransactionHeaderView, didTapAddTransactionButton button: UIButton) {
        
    }
    
    func transactionHeaderView(_ view: TransactionHeaderView, didTapTopUpBalanceButton button: UIButton) {
        
    }
}


extension UITableView {
    func setAndLayoutTableHeaderView(header: UIView) {
//        self.tableHeaderView = header
//        header.setNeedsLayout()
//        header.layoutIfNeeded()
        let height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = header.frame
        frame.size.height = height
        header.frame = frame
        self.tableHeaderView = header
    }
}
