//
//  Array.swift
//  Vocablo
//
//  Created by Marcel Jäger on 20.11.23.
//

import Foundation
import SwiftData

extension Array {
    
    ///Append a new element, when the condition is true.
    mutating func append(_ newElement: Element, when: (Array<Element>) -> Bool) {
        if when(self) {
            self.append(newElement)
        }
    }
    
    subscript(indexSet: IndexSet) -> Self {
        var returnedArray: Array<Element> = []
        for index in indexSet {
            if index < self.count {
                returnedArray.append(self[index])
            }
        }
        
        return returnedArray
    }
}

extension Array where Element: PersistentModel{
    subscript(byIdentifiers identifiers: Set<PersistentIdentifier>) -> Array<Element> {
        var returnedArray: Array<Element> = []
        for item in self {
            guard identifiers.contains(item.id) else { continue }
            returnedArray.append(item)
        }
        return returnedArray
    }
}
