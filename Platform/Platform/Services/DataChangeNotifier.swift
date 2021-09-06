//
//  DataChangeNotifier.swift
//  Platform
//
//  Created by Artem Shkirta on 06.09.2021.
//

import Foundation
import Domain

final class DataChangeNotifier: ObserverUseCase {
    
    private var observers: [ChangeAction: WeakSet<DataChangeObserver>] = [:]
    
    func addObserver(_ observer: DataChangeObserver, forActions actions: ChangeAction...) {
        actions.forEach { action in
            let actionObservers = observers[action] ?? WeakSet<DataChangeObserver>()
            actionObservers.append(observer)
            observers[action] = actionObservers
        }
    }
    
    func removeObserver(_ observer: DataChangeObserver, forActions actions: ChangeAction...) {
        actions.forEach { action in
            observers[action].flatMap { $0.remove(observer) }
        }
    }
    
    func notify(about actions: ChangeAction...) {
        actions.forEach { action in
            observers[action]?.forEach { $0.domain(didPerform: action) }
        }
    }
}
