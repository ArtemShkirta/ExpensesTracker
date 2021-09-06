//
//  DateFormatter+Extension.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 05.09.2021.
//

import class Foundation.DateFormatter

extension DateFormatter {
    
    static var transaction: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd.MM.yyyy"
        formatter.locale = .current
        formatter.timeZone = .current
        return formatter
    }
}
