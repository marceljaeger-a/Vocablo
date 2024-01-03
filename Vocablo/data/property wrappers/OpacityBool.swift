//
//  OpacityBool.swift
//  Vocablo
//
//  Created by Marcel Jäger on 15.12.23.
//

import Foundation

@propertyWrapper
struct OpacityBool {
    
    //MARK: - Instanz Properties
    
    var wrappedValue: Bool
    let trueValue: Double
    let falseValue: Double
    
    ///Returns the trueValue when the wrappedValue is true.
    ///Returns the falseValue when the wrappedValue is false.
    var projectedValue: Double {
        switch wrappedValue {
        case true:
            return trueValue
        case false:
            return falseValue
        }
    }
}



//MARK: - Initialiser

extension OpacityBool {
    init(wrappedValue: Bool, onTrue: Double = 1, onFalse: Double = 0) {
        self.init(wrappedValue: wrappedValue, trueValue: onTrue, falseValue: onFalse)
    }
}
