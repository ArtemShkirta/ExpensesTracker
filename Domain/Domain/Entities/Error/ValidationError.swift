//
//  ValidationError.swift
//  Domain
//
//  Created by Artem Shkirta on 06.09.2021.
//

import Foundation

public enum ValidationError: Error {
    case priceEmpty
    case sortEmpty
    
    public var asAppError: AppError {
        .validation(self)
    }
}

extension ValidationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .priceEmpty:
            return LocalizedError(key: "validation.expenses.price.empty")
        case .sortEmpty:
            return LocalizedError(key: "validation.expenses.sort.empty")
        }
    }
}
