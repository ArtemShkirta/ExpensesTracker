//
//  Bitcoin.swift
//  Domain
//
//  Created by Artem Shkirta on 06.09.2021.
//

import Foundation

public struct Bitcoin {
    public let code: String
    public let rate: Decimal
    
    public var fullDescription: String {
        NumberFormatter.price.string(for: rate) ?? "NaN" + " \(code)"
    }
    
    public init(code: String, rate: Decimal) {
        self.code = code
        self.rate = rate
    }
}
