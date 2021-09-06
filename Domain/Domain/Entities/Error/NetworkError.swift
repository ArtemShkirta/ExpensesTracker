//
//  NetworkError.swift
//  Domain
//
//  Created by Artem Shkirta on 06.09.2021.
//

import Foundation

public enum NetworkError: Error {
    case incorretURL
    case incorrectJSON
    case parseError
    case connection(Error)
    
    public var asAppError: AppError {
        .network(self)
    }
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .connection:
            return LocalizedError(key: "network.connection")
        case .incorretURL, .incorrectJSON, .parseError:
            return LocalizedError(key: "network.internal")
        }
    }
}
