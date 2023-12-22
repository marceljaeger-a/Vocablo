//
//  Date.swift
//  Vocablo
//
//  Created by Marcel Jäger on 20.12.23.
//

import Foundation

extension Date {
    var isReferenceDate: Bool {
        if self.timeIntervalSinceReferenceDate == 0 {
            return true
        }else {
            return false
        }
    }
}
