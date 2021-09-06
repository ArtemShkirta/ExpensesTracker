//
//  PriceTextProcessor.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 06.09.2021.
//

import Foundation

class PriceTextProcessor: LengthTextProcessor {
    
    private let regex = #"(\-?\d{0,8}\.?+\d{0,2}?)"#
    
    override func shouldReplaceCharacters<Input>(in range: NSRange, replacement: String, textInput: Input) -> Bool where Input : TextInput {
        let result = textInput.text(changingCharactersIn: range, replacement: replacement)
    
        return !result.starts(with: "0") &&
            matches(result, regex: regex) &&
            super.shouldReplaceCharacters(in: range, replacement: replacement, textInput: textInput)
    }
    
    private func matches(_ text: String, regex: String) -> Bool {
        NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }
}
