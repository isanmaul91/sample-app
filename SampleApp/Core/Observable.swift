//
//  Observable.swift
//  SampleApp
//
//  Created by Muhammad Ihsan Maula on 04/04/23.
//

import Foundation

class Observable<T> {
    
    var value: T {
        didSet {
            notifyAllObserver()
        }
    }
    
    init(value: T) {
        self.value = value
    }
    
    deinit {
        observers.removeAll()
    }
    
    private var observers: [String: (T) -> Void] = [:]
    
    private func notifyAllObserver() {
        observers.values.forEach { $0(value) }
    }
    
    func addObserver(_ object: AnyObject, closure: @escaping (T) -> Void) {
        observers[object.description] = closure
    }
}
