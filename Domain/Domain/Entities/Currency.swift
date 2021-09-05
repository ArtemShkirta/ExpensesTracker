//
//  Currency.swift
//  Domain
//
//  Created by Artem Shkirta on 03.09.2021.
//

public enum Currency: Int16, CaseIterable {
    
    case unknown
    case bitcoin
    case usd
    
    // MARK: - Properties
    public var isoCode: String {
        let isoCode: String
        switch self {
        case .bitcoin:
            isoCode = Localized("currency.bitcoin")
        case .usd:
            isoCode = Localized("currency.usd")
        case .unknown:
            isoCode = Localized("currency.unknown")
        }
        return isoCode
    }
    
    // MARK: - Life Cycle
    public init(isoCode: String) {
        self = Currency.allCases.first { $0.isoCode == isoCode } ?? .unknown
    }
    
    public init(id: Int16) {
        self = Currency.allCases.first { $0.rawValue == id } ?? .unknown
    }
}
