//
//  Expenses.swift
//  Domain
//
//  Created by Artem Shkirta on 03.09.2021.
//

public final class Expenses: Transaction {
    
    public enum Sort: Int16 {
        case groceries, taxi, electronics, restaurant, other
    }
    
    // MARK: - Properties
    public var sort: Sort
    
    // MARK: - Life Cycle
    public init(createDate: Date, price: Price, sort: Sort) {
        self.sort = sort
        super.init(createDate: createDate, price: price, kind: .expenses)
    }
}
