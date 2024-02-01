//
//  Duplicateable.swift
//  Vocablo
//
//  Created by Marcel Jäger on 31.01.24.
//

import Foundation

protocol Duplicateable {
    ///Defines if **rhs** is a duplicate of **lhs** and returns true if it is.
    static func isDuplicate(lhs: Self, rhs: Self) -> Bool
}
