//
//  Localized.swift
//  Domain
//
//  Created by Artem Shkirta on 05.09.2021.
//

import Foundation

func Localized(_ key: String) -> String {
    NSLocalizedString(key, bundle: Bundle(identifier: "com.artemShkirta.Domain") ?? .main, comment: "")
}

func LocalizedError(key: String) -> String {
    NSLocalizedString(key, tableName: "Error", bundle: Bundle(identifier: "com.artemShkirta.Domain") ?? .main, comment: "")
}
