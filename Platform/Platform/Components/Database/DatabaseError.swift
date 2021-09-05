//
//  DatabaseError.swift
//  Platform
//
//  Created by Artem Shkirta on 04.09.2021.
//

import Foundation

public enum DatabaseError: LocalizedError {
    case underlying(Error)
    case cantExecute
}
