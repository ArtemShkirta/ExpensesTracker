//
//  TransactionUseCase.swift
//  Domain
//
//  Created by Artem Shkirta on 02.09.2021.
//

import protocol CoreData.NSFetchedResultsControllerDelegate

public protocol TransactionUseCase {
    func makeDataSource(delegate: NSFetchedResultsControllerDelegate) -> AnyDataSource<Transaction>
}
