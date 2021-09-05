//
//  Localized.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 05.09.2021.
//

import func Foundation.NSLocalizedString

func Localized(_ key: String) -> String {
    NSLocalizedString(key, comment: "")
}

func LocalizedAlert(_ key: String) -> String {
    NSLocalizedString(key, tableName: "Alert", comment: "")
}
