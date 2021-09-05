//
//  NumberFormatter+Extension.swift
//  Domain
//
//  Created by Artem Shkirta on 03.09.2021.
//

import Foundation

extension NumberFormatter {
    static var price: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        formatter.alwaysShowsDecimalSeparator = false
        formatter.groupingSeparator = " "
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        formatter.roundingMode = .floor
        return formatter
    }
}
