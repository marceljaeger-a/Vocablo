//
//  Array.swift
//  Vocablo
//
//  Created by Marcel Jäger on 20.11.23.
//

import Foundation

extension Array {
    mutating func append(_ newElement: Element, when: (Array<Element>) -> Bool) {
        if when(self) {
            self.append(newElement)
        }
    }
}
