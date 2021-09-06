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
    func transactionListVCShowTopUpBalanceAlert(_ controller: TransactionListVC, callback: Command<String>)
    func transactionListVC(_ controller: TransactionListVC, didTapAddTransactionButton button: UIButton)
    func transactionListVC(_ controller: TransactionListVC, shouldShowError error: Error)
}

final class TransactionListVC: UIViewController, UseCasesConsumer {
    
    typealias UseCases = HasTransactionUseCase & HasObserverUseCase & HasBitcoinUseCase
    
    // MARK: - Public Properties
    weak var delegate: TransactionListVCDelegate?
    
    // MARK: - Private Properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .grouped)
        tableView.dataSource = self
        tableView.setupAndLayoutTableHeaderView(headerView)
        tableView.register(TransactionSpendingTVC.self, TransactionIncomeTVC.self)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private lazy var headerView: TransactionHeaderView = {
        let headerView = TransactionHeaderView(delegate: self, frame: UIScreen.main.bounds)
        return headerView
    }()
    
    private lazy var topUpBalanceCallback: Command<String> = Command { [weak self] value in
        guard let income = Double(value) else { return }
        self?.useCases.transaction.save(transaction: Income(price: Price(value: Decimal(income))), completion: { _ in
            
        })
    }
    
    private lazy var dataSource: AnyDataSource<Transaction> = useCases.transaction.makeDataSource(delegate: self)
    
    // MARK: - Life Cycle
    override func loadView() {
        view = tableView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    deinit {
        useCases.observer.removeObserver(self, forActions: .balanceUpdated, .shouldUpdateRate)
    }
    
    // MARK: - Setup
    private func setupView() {
        useCases.observer.addObserver(self, forActions: .balanceUpdated, .shouldUpdateRate)
        performFetch()
        checkCurrentBalance()
        checkExchangeRate()
    }
    
    private func performFetch() {
        do {
            try dataSource.performFetch()
        } catch {
            showError(error)
        }
    }
    
    private func checkCurrentBalance() {
        useCases.transaction.currentBalance { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let newBalance):
                    self?.headerView.updateBalance(newBalance)
                case .failure(let error):
                    self?.showError(error)
                }
            }
        }
    }
    
    private func checkExchangeRate() {
        useCases.bitcoin.bitcoinExchangeRate { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let newRate):
                    self?.headerView.updateExchangeRate(newRate)
                case .failure(let error):
                    self?.showError(error)
                }
            }
        }
    }
    
    private func showError(_ error: Error) {
        delegate?.transactionListVC(self, shouldShowError: error)
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        PriceTextProcessor(max: 10).shouldReplaceCharacters(in: range, replacement: string, textInput: textField)
    }
}

// MARK: - TransactionHeaderViewDelegate {
extension TransactionListVC: TransactionHeaderViewDelegate {
    func transactionHeaderView(_ view: TransactionHeaderView, didTapAddTransactionButton button: UIButton) {
        delegate?.transactionListVC(self, didTapAddTransactionButton: button)
    }
    
    func transactionHeaderView(_ view: TransactionHeaderView, didTapTopUpBalanceButton button: UIButton) {
        delegate?.transactionListVCShowTopUpBalanceAlert(self, callback: topUpBalanceCallback)
    }
}

// MARK: - DataChangeObserver
extension TransactionListVC: DataChangeObserver {
    func domain(didPerform action: ChangeAction) {
        switch action {
        case .balanceUpdated:
            checkCurrentBalance()
        case .shouldUpdateRate:
            checkExchangeRate()
        }
    }
}
