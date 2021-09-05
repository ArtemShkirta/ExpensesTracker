//
//  Price.swift
//  Domain
//
//  Created by Artem Shkirta on 03.09.2021.
//

public struct Price {
    
    // MARK: - Properties
    public let value: Decimal
    public let currency: Currency
    
    // MARK: - Life Cycle
    public init(value: Decimal, currency: Currency) {
        self.value = value
        self.currency = currency
    }
}

extension Price {
    public var displayShort: String {
        NumberFormatter.price.string(for: value) ?? "NaN"
    }
    
    public var displayFull: String {
        "\(displayShort) \(currency.isoCode)"
    }
    
    public func map(_ transform: (Decimal) -> Decimal) -> Price {
        return Price(value: transform(value), currency: currency)
    }
}
