//
//  NetworkError.swift
//  Platform
//
//  Created by Artem Shkirta on 05.09.2021.
//

import Foundation

enum NetworkError: Error {
    case incorretURL
    case incorrectJSON
    case parseError
}
