//
//  UIAlertAction+Helpers.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 05.09.2021.
//

import class UIKit.UIAlertAction

extension UIAlertAction {
    static func okay(style: UIAlertAction.Style = .default, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        UIAlertAction(title: LocalizedAlert("action.ok"), style: style, handler: handler)
    }
    
    static func cancel(style: UIAlertAction.Style = .cancel, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        UIAlertAction(title: LocalizedAlert("action.cancel"), style: style, handler: handler)
    }
}
