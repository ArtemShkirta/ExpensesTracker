//
//  UIView+Helpers.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 02.09.2021.
//

import UIKit.UIView

extension UIView {
    var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue  }
    }
    
    var borderColor: UIColor? {
        get { layer.borderColor.flatMap(UIColor.init) }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
}
