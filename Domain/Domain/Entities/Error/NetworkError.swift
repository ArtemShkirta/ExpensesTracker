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
    
    public var asAppError: AppError {
        .network(self)
    }
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        LocalizedError(key: "network.internal")
    }
}
