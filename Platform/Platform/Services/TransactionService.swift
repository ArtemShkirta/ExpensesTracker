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
        observers[.updateBalance(newBalance: 0)]?.append(observer)
    }
    
    func currentBalance(completion: @escaping (Result<Decimal, AppError>) -> Void) {
        database.find(.sum, of: \CDTransaction.price) { result in
            completion(result.mapError { _ in AppError.database }.map { $0.decimalValue })
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
    
    func save<T: Transaction & Persistable>(transaction: T, completion: @escaping (Result<T, Error>) -> Void) {
        database.save(transaction) { result in
            completion(result.mapError { _ in AppError.database })
        }
    }
    
    // MARK: - Hepler Methods
    private func makeTransactionFetchRequest(fetchBatchSize: Int = 5) -> NSFetchRequest<CDTransaction> {
        let fetchRequest: NSFetchRequest<CDTransaction> = CDTransaction.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CDTransaction.createDate, ascending: false)]
        fetchRequest.fetchBatchSize = fetchBatchSize
        return fetchRequest
    }
}
