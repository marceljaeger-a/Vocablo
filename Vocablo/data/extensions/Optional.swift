//
//  Optional.swift
//  Vocablo
//
//  Created by Marcel Jäger on 19.02.24.
//

import Foundation
import SwiftData

extension Optional where Wrapped == any Collection{
    var emptyableUnwrapped: Wrapped {
        if self == nil {
            return []
        }
        return self!
    }
}
