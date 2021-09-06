//
//  TransactionService.swift
//  Platform
//
//  Created by Artem Shkirta on 04.09.2021.
//

import Domain
import CoreData

final class TransactionService: TransactionUseCase {
    
    // MARK: - Properties
    private let database: CDDatabase
    private var observers: [ChangeAction: WeakSet<DataChangeObserver>] = [:]
    private var currentBalance: Decimal?
    
    // MARK: - Lifecycle
    init(database: CDDatabase) {
        self.database = database
    }
    
    func addObserver(_ observer: DataChangeObserver, forActions actions: ChangeAction...) {
        actions.forEach { action in
            let actionObservers = observers[action] ?? WeakSet<DataChangeObserver>()
            actionObservers.append(observer)
            observers[action] = actionObservers
        }
    }
    
    func removeObserver(_ observer: DataChangeObserver, forActions actions: ChangeAction...) {
        actions.forEach { action in
            observers[action].flatMap { $0.remove(observer) }
        }
    }
    
    func currentBalance(completion: @escaping (Result<Decimal, AppError>) -> Void) {
        if let currentBalance = currentBalance {
            completion(.success(currentBalance))
            return
        }
        database.find(.sum, of: \CDTransaction.price) { [weak self] result in
            self?.currentBalance = try? result.get().decimalValue
            completion(result.mapError(\.asAppError).map { $0.decimalValue })
        }
    }
    
    func makeDataSource(delegate: NSFetchedResultsControllerDelegate) -> AnyDataSource<Transaction> {
        let mapper: (CDTransaction) throws -> Transaction = { transaction in
            switch transaction {
            case let expenses as CDExpenses:
                return try Expenses(expenses)
            default:
                return try Income(transaction)
            }
        }
        return AnyDataSource(CDDataSource(fetchRequest: makeTransactionFetchRequest(),
                                   context: database.mainContext,
                                   mapper: mapper,
                                   sectionNameKeyPath: NSExpression(forKeyPath: \CDTransaction.normalizedCreateDate).keyPath,
                                   delegate: delegate))
    }
    
    func save<T: Transaction & Persistable>(transaction: T, completion: @escaping (Result<T, AppError>) -> Void) {
        database.save(transaction) { [weak self] result in
            switch result {
            case .success(let value):
                let balance = self?.currentBalance ?? 0
                self?.currentBalance = balance + value.price.value
                self?.observers[.balanceUpdated]?.forEach { $0.domain(didPerform: .balanceUpdated) }
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error.asAppError))
            }
        }
    }
    
    // MARK: - Hepler Methods
    private func makeTransactionFetchRequest(fetchBatchSize: Int = 20) -> NSFetchRequest<CDTransaction> {
        let fetchRequest: NSFetchRequest<CDTransaction> = CDTransaction.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CDTransaction.createDate, ascending: false)]
        fetchRequest.fetchBatchSize = fetchBatchSize
        return fetchRequest
    }
}
