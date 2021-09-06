//
//  TextProcessor.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 06.09.2021.
//

import UIKit

protocol TextProcessor {
    func shouldReplaceCharacters<Input: TextInput>(in range: NSRange, replacement: String, textInput: Input) -> Bool
}
