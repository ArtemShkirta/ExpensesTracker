//
//  DataChangeObserver.swift
//  Domain
//
//  Created by Artem Shkirta on 05.09.2021.
//

import Foundation

public enum ChangeAction: Hashable {
    case balanceUpdated
    case shouldUpdateRate
}

public protocol DataChangeObserver: AnyObject {
    func domain(didPerform action: ChangeAction)
}
