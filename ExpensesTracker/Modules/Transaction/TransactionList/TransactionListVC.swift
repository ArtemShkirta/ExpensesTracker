//
//  TransactionListVC.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 02.09.2021.
//

import UIKit
import Domain
import CoreData

protocol TransactionListVCDelegate: AnyObject {
    func showTopUpBalanceAlert(_ controller: TransactionListVC, callback: Command<String>)
}

final class TransactionListVC: UIViewController, UseCasesConsumer {
    
    typealias UseCases = HasTransactionUseCase
    
    // MARK: - Public Properties
    weak var delegate: TransactionListVCDelegate?
    
    // MARK: - Private Properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .grouped)
        tableView.dataSource = self
        tableView.setAndLayoutTableHeaderView(header: headerView)
//        tableView.tableHeaderView = headerView
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
    
    private lazy var topUpBalanceCallback: Command<String> = Command { [weak self] value in
        guard let income = Double(value) else { return }
        self?.useCases.transaction.save(transaction: Income(createDate: Date(), price: Price(value: Decimal(income), currency: .bitcoin)), completion: { _ in
            
        })
    }
    
    private lazy var dataSource: AnyDataSource<Transaction> = useCases.transaction.makeDataSource(delegate: self)
    
    // MARK: - Life Cycle
    override func loadView() {
        view = tableView
        try? dataSource.performFetch()
    }
    
    // MARK: - Helper Methods
//    private func showTopUpBalanceAction() {
//
//    }
//
}

// MARK: - Makeable
extension TransactionListVC: Makeable {
    static func make() -> TransactionListVC {
        TransactionListVC()
    }
}

// MARK: - UITableViewDataSource
extension TransactionListVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        dataSource.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.numberOfRows(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let transaction = try? dataSource.object(at: indexPath) else {
            fatalError("Can't get transaction")
        }
        switch transaction {
        case let income as Income:
            return tableView.makeCell(TransactionIncomeTVC.self) { cell in
                cell.config(price: income.price, date: income.createDate)
            }
        case let expenses as Expenses:
            return tableView.makeCell(TransactionSpendingTVC.self) { cell in
                cell.config(sort: expenses.sort, price: expenses.price, date: expenses.createDate)
            }
        default:
            fatalError("Incorrect transaction type")
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        dataSource.sectionTitle(for: section)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TransactionListVC: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .right)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .right)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .none)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            if indexPath != newIndexPath {
                tableView.deleteRows(at: [indexPath], with: .right)
                tableView.insertRows(at: [newIndexPath], with: .right)
            } else {
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        @unknown default: break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections([sectionIndex], with: .right)
        case .delete:
            tableView.deleteSections([sectionIndex], with: .right)
        case .move:
            tableView.reloadSections([sectionIndex], with: .right)
        case .update:
            tableView.reloadSections([sectionIndex], with: .right)
        @unknown default: break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

// MARK: - UITextFieldDelegate
extension TransactionListVC: UITextFieldDelegate {
    
}

// MARK: - TransactionHeaderViewDelegate {
extension TransactionListVC: TransactionHeaderViewDelegate {
    func transactionHeaderView(_ view: TransactionHeaderView, didTapAddTransactionButton button: UIButton) {
        
    }
    
    func transactionHeaderView(_ view: TransactionHeaderView, didTapTopUpBalanceButton button: UIButton) {
        delegate?.showTopUpBalanceAlert(self, callback: topUpBalanceCallback)
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
