//
//  Transaction.swift
//  Domain
//
//  Created by Artem Shkirta on 03.09.2021.
//

public class Transaction {
    
    public enum Kind: Int16 {
        case expenses
        case income
    }
    
    // MARK: -  Properties
    public let createDate: Date
    public let price: Price
    public let kind: Kind
    
    // MARK: - Life Cycle
    init(createDate: Date, price: Price, kind: Kind) {
        self.createDate = createDate
        self.price = price
        self.kind = kind
    }
}
