//
//  UIView+EndEditing.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 06.09.2021.
//

import UIKit.UIView

extension UIView {
    func addHideKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tapGesture.cancelsTouchesInView = false
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
    }
}
