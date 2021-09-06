//
//  TextInput.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 06.09.2021.
//

import UIKit

protocol TextInput: AnyObject {
    var requiredText: String { get set }
    
    func text(changingCharactersIn range: NSRange, replacement: String) -> String
    func moveCursorToEnd()
}

extension TextInput {
    func text(changingCharactersIn range: NSRange, replacement: String) -> String {
        (requiredText as NSString).replacingCharacters(in: range, with: replacement)
    }
}

extension UITextField: TextInput {
    var requiredText: String {
        get { text ?? "" }
        set { text = newValue }
    }
    
    func moveCursorToEnd() {
        selectedTextRange = textRange(from: endOfDocument, to: endOfDocument)
    }
}

extension UITextView: TextInput {
    var requiredText: String {
        get { text ?? "" }
        set { text = newValue }
    }
    
    func moveCursorToEnd() {
        selectedTextRange = textRange(from: endOfDocument, to: endOfDocument)
    }
}

extension UISearchBar: TextInput {
    var requiredText: String {
        get { text ?? "" }
        set { text = newValue }
    }
    
    func moveCursorToEnd() {
        searchTextField.moveCursorToEnd()
    }
}
