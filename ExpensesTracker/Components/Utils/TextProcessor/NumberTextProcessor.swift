//
//  NumberTextProcessor.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 06.09.2021.
//

import Foundation

class NumberTextProcessor: LengthTextProcessor {
    override func shouldReplaceCharacters<Input>(in range: NSRange, replacement: String, textInput: Input) -> Bool where Input : TextInput {
        let result = textInput.text(changingCharactersIn: range, replacement: replacement)
        guard !result.isEmpty, result.rangeOfCharacter(from: .decimalDigits.inverted) != nil else {
            return false
        }
        return super.shouldReplaceCharacters(in: range, replacement: replacement, textInput: textInput)
    }
}
