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
    
    /// This function append both singular objects and/or it's array in a variadic fashion
    ///
    /// - Parameter objects: the objects or an array of the objects
    mutating func appendVar(_ objects: Any...) {
        var temp: [Element] = []
        
        for object in objects {
            if let object = object as? Element {
                temp.append(object)
            } else if let object = object as? [Element] {
                temp.append(contentsOf: object)
            } else {
                #if DEBUG
                fatalError("This type of object is not applicable.")
                #endif
            }
        }
        
        append(contentsOf: temp)
    }
}
