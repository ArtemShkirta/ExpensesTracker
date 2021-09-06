//
//  DatabaseError.swift
//  Domain
//
//  Created by Artem Shkirta on 06.09.2021.
//

import Foundation

public enum DatabaseError: Error {
    case underlying(Error)
    case cantExecute

    public var asAppError: AppError {
        .database(self)
    }
}

extension DatabaseError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .underlying(let error):
            return error.localizedDescription
        case .cantExecute:
            return LocalizedError(key: "database.cantExecute")
        }
    }
}
