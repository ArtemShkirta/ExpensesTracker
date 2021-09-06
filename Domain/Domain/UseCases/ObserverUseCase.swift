//
//  ObserverUseCase.swift
//  Domain
//
//  Created by Artem Shkirta on 06.09.2021.
//

public protocol ObserverUseCase {
    func addObserver(_ observer: DataChangeObserver, forActions actions: ChangeAction...)
    func removeObserver(_ observer: DataChangeObserver, forActions actions: ChangeAction...)
}
