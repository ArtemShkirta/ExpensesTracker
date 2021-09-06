//
//  LengthTextProcessor.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 06.09.2021.
//

import UIKit

class LengthTextProcessor: TextProcessor {
    let max: Int
    
    init(max: Int) {
        self.max = max
    }
    
    func shouldReplaceCharacters<Input>(in range: NSRange, replacement: String, textInput: Input) -> Bool where Input : TextInput {
        let result = textInput.text(changingCharactersIn: range, replacement: replacement)
        if result.trimmingCharacters(in: .whitespacesAndNewlines).utf8.count > max, let text = String(result.utf8.prefix(max)) {
            textInput.requiredText = text
            DispatchQueue.main.async {
                textInput.moveCursorToEnd()
            }
        }
        return result.utf8.count <= max
    }
}

