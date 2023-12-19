//
//  Array.swift
//  Vocablo
//
//  Created by Marcel Jäger on 20.11.23.
//

import Foundation

extension Array {
    
    ///Append a new element, when the condition is true.
    mutating func append(_ newElement: Element, when: (Array<Element>) -> Bool) {
        if when(self) {
            self.append(newElement)
        }
    }
}
