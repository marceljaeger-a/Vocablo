//
//  IsAnswerAvailableFocusedValue.swift
//  Vocablo
//
//  Created by Marcel Jäger on 25.03.24.
//

import Foundation
import SwiftUI

struct IsAnswerVisibleFocusedValue: FocusedValueKey {
    typealias Value = Binding<Bool>
}

extension FocusedValues {
    var isAnswerVisible: Binding<Bool>? {
        get {
            self[IsAnswerVisibleFocusedValue.self]
        }
        set {
            self[IsAnswerVisibleFocusedValue.self] = newValue
        }
    }
}
