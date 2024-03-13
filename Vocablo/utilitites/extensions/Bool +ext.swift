//
//  Bool +ext.swift
//  Vocablo
//
//  Created by Marcel Jäger on 13.03.24.
//

import Foundation

extension Bool: Comparable {
    public static func < (lhs: Bool, rhs: Bool) -> Bool {
        lhs == false && rhs == true
    }
}
