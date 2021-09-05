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
    
    // MARK: - Private Properties
    private let database: CDDatabase
    
    // MARK: - Life Cycle
    init() {
        database = CDDatabase()
        transaction = TransactionService(database: database)
    }
}
