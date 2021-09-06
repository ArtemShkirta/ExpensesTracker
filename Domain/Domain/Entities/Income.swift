//
//  Income.swift
//  Domain
//
//  Created by Artem Shkirta on 03.09.2021.
//

public final class Income: Transaction {
    
    // MARK: - Life Cycle
    public init(price: Price, createDate: Date = Date()) {
        super.init(createDate: createDate, price: price, kind: .income)
    }
}
