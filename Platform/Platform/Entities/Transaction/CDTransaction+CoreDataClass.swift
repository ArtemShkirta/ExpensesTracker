//
//  CDTransaction+CoreDataClass.swift
//  
//
//  Created by Artem Shkirta on 03.09.2021.
//
//

import Foundation
import CoreData
import Domain

@objc(CDTransaction)
public class CDTransaction: NSManagedObject {

}

// MARK: - Persistable
extension Income: Persistable {
    public func update(_ object: CDTransaction, in context: NSManagedObjectContext) throws {
        object.createDate = createDate
        object.price = NSDecimalNumber(decimal: price.value)
        object.currency = price.currency.rawValue
        object.kind = Transaction.Kind.income.rawValue
    }
}

// MARK: - DatabaseRepresentable
extension Income: DatabaseRepresentable {
    public convenience init(_ object: CDTransaction) throws {
        self.init(createDate: object.createDate,
                  price: Price(value: object.price.decimalValue, currency: Currency(id: object.currency)))
    }
}
