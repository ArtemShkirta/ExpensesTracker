//
//  Expenses.swift
//  Domain
//
//  Created by Artem Shkirta on 03.09.2021.
//

public final class Expenses: Transaction {
    
    public enum Sort: Int16 {
        case groceries, taxi, electronics, restaurant, other
        
        public var name: String {
            let name: String
            switch self {
            case .groceries:
                name = Localized("expenses.sort.groceries")
            case .taxi:
                name = Localized("expenses.sort.taxi")
            case .electronics:
                name = Localized("expenses.sort.electronics")
            case .restaurant:
                name = Localized("expenses.sort.restaurant")
            case .other:
                name = Localized("expenses.sort.other")
            }
            return name
        }
    }
    
    // MARK: - Properties
    public var sort: Sort
    
    // MARK: - Life Cycle
    public init(createDate: Date, price: Price, sort: Sort) {
        self.sort = sort
        super.init(createDate: createDate, price: price, kind: .expenses)
    }
}
