//
//  UseCasesProvider.swift
//  Domain
//
//  Created by Artem Shkirta on 02.09.2021.
//

public protocol HasTransactionUseCase {
    var transaction: TransactionUseCase { get }
}

public protocol HasObserverUseCase {
    var observer: ObserverUseCase { get }
}

public protocol HasBitcoinUseCase {
    var bitcoin: BitcoinUseCase { get }
}

public typealias UseCases =
    HasTransactionUseCase
    & HasObserverUseCase
    & HasBitcoinUseCase

public protocol UseCasesProvider: UseCases {}
