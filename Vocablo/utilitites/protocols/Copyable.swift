//
//  Copyable.swift
//  Vocablo
//
//  Created by Marcel Jäger on 12.03.24.
//

import Foundation

protocol Copyable {
    init(copyOf value: Self)
    func copy() -> Self
}

extension Copyable {
    func copy() -> Self {
        Self.init(copyOf: self)
    }
}
