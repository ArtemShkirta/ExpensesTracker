//
//  CDExpenses+CoreDataClass.swift
//  
//
//  Created by Artem Shkirta on 03.09.2021.
//
//

import Foundation
import CoreData
import Domain

@objc(CDExpenses)
public class CDExpenses: CDTransaction {

}

// MARK: - Persistable
extension Expenses: Persistable {
    public func update(_ object: CDExpenses, in context: NSManagedObjectContext) throws {
        object.sort = sort.rawValue
        object.createDate = createDate
        object.price = NSDecimalNumber(decimal: price.value)
        object.currency = price.currency.rawValue
        object.kind = Transaction.Kind.expenses.rawValue
        object.normalizedCreateDate = DateFormatter.transaction.string(from: createDate)
    }
}

// MARK: - DatabaseRepresentable
extension Expenses: DatabaseRepresentable {
    public convenience init(_ object: CDExpenses) throws {
        self.init(price: Price(value: object.price.decimalValue, currency: Currency(id: object.currency)),
                  sort: Expenses.Sort(rawValue: object.sort) ?? .other,
                  createDate: object.createDate)
    }
}
