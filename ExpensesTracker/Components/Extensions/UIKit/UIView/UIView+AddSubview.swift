//
//  UIView+AddSubview.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 02.09.2021.
//

import UIKit.UIView

extension UIView {
    func addSubview(_ view: UIView, constraints: [NSLayoutConstraint]) {
        addSubview(view)
        if !constraints.isEmpty {
            view.translatesAutoresizingMaskIntoConstraints = false
            addConstraints(constraints)
        }
    }
}
