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
    
    // MARK: - Lifecycle
    init(database: CDDatabase) {
        self.database = database
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
                                   sectionNameKeyPath: NSExpression(forKeyPath: \CDTransaction.createDate).keyPath,
                                   delegate: delegate))
    }
    
    // MARK: - Hepler Methods
    private func makeTransactionFetchRequest(fetchBatchSize: Int = 20) -> NSFetchRequest<CDTransaction> {
        let fetchRequest: NSFetchRequest<CDTransaction> = CDTransaction.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CDTransaction.createDate, ascending: true)]
        fetchRequest.fetchBatchSize = fetchBatchSize
        return fetchRequest
    }
}
