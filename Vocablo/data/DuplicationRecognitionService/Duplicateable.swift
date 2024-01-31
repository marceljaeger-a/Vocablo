//
//  Duplicateable.swift
//  Vocablo
//
//  Created by Marcel Jäger on 31.01.24.
//

import Foundation

protocol Duplicateable {
    static func isDuplicate(lhs: Self, rhs: Self) -> Bool
}
