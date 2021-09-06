//
//  Platform.swift
//  Platform
//
//  Created by Artem Shkirta on 04.09.2021.
//

import Domain

public final class Platform: UseCasesProvider {
    
    // MARK: - Public Properties
    public let transaction: TransactionUseCase
    public var observer: ObserverUseCase { notifier }
    public let bitcoin: BitcoinUseCase
    
    // MARK: - Private Properties
    private let database: CDDatabase
    private let notifier: DataChangeNotifier
    
    // MARK: - Life Cycle
    public init() {
        database = CDDatabase()
        notifier = DataChangeNotifier()
        bitcoin = BitcoinService(notifier: notifier)
        transaction = TransactionService(database: database, notifier: notifier)
    }
}
