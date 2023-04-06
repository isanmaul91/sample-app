//
//  Array+Ext.swift
//  SampleApp
//
//  Created by Muhammad Ihsan Maula on 04/04/23.
//

extension Array {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        get {
            if indices.contains(index) {
                return self[index]
            }
            return nil
        }
        
        set(newValue) {
            if let solidValue = newValue, indices.contains(index) {
                self[index] = solidValue
            }
        }
    }
}
