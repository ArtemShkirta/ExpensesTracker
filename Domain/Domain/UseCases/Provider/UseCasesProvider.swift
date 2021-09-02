//
//  UseCasesProvider.swift
//  Domain
//
//  Created by Artem Shkirta on 02.09.2021.
//

public protocol HasTransactionUseCase {
    var transaction: TransactionUseCase { get }
}

public typealias UseCases =
    HasTransactionUseCase

public protocol UseCasesProvider: UseCases {}
