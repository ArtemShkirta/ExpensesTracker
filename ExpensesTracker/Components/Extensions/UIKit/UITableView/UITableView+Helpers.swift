//
//  UITableView+Helpers.swift
//  ExpensesTracker
//
//  Created by Artem Shkirta on 05.09.2021.
//

import UIKit.UITableView

extension UITableView {
    func register(_ types: UITableViewCell.Type...) {
        types.forEach {
            register($0, forCellReuseIdentifier: String(describing: $0))
        }
    }
    
    func dequeueReusableCell<Cell: UITableViewCell>(_ type: Cell.Type) -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: type)) as? Cell else {
            fatalError("Failed to dequeue cell with identifier: \(String(describing: type))" )
        }
        
        return cell
    }
    
    func makeCell<T: UITableViewCell>(_ type: T.Type, builder: (T) -> Void) -> T {
        let cell = dequeueReusableCell(type)
        builder(cell)
        return cell
    }
}
