//
//  UILabel+Config.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 02.09.2021.
//

import UIKit.UILabel

extension UILabel {
    
    struct Config {
        var text: String?
        var font: UIFont
        var textColor: UIColor
        var textAlignment: NSTextAlignment
        var numberOfLines: Int
        
        init(text: String? = nil,
             font: UIFont = .systemFont(ofSize: 20),
             textColor: UIColor = .black,
             textAlignment: NSTextAlignment = .center,
             numberOfLines: Int = 0) {
            self.text = text
            self.font = font
            self.textColor = textColor
            self.textAlignment = textAlignment
            self.numberOfLines = numberOfLines
        }
    }
    
    convenience init(config: UILabel.Config) {
        self.init()
        text = config.text
        textColor = config.textColor
        font = config.font
        textAlignment = config.textAlignment
        numberOfLines = config.numberOfLines
    }
}

extension UILabel.Config {
    static func title(_ title: String) -> UILabel.Config {
        UILabel.Config(text: title,
                       font: .systemFont(ofSize: 20, weight: .semibold),
                       textColor: .systemGray)
    }
    
    static func parameter(_ color: UIColor) -> UILabel.Config {
        UILabel.Config(font: .systemFont(ofSize: 30),
                       textColor: color)
    }
}
