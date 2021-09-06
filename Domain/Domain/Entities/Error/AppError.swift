//
//  AppError.swift
//  Domain
//
//  Created by Artem Shkirta on 05.09.2021.
//

import Foundation

public enum AppError: Error {
    case database(DatabaseError)
    case validation(ValidationError)
    case network(NetworkError)
}

extension AppError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .database(let error):
            return error.localizedDescription
        case .validation(let error):
            return error.localizedDescription
        case .network(let error):
            return error.localizedDescription
        }
    }
}

