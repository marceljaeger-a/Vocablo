//
//  SelectedListFocusedValueKey.swift
//  Vocablo
//
//  Created by Marcel Jäger on 05.03.24.
//

import Foundation
import SwiftUI


struct SelectedDeckValueFocusedKey: FocusedValueKey {
    typealias Value = Binding<DeckSelectingValue>
}

extension FocusedValues {
    var selectedDeckValue: Binding<DeckSelectingValue>? {
        get {
            self[SelectedDeckValueFocusedKey.self]
        }
        set {
            self[SelectedDeckValueFocusedKey.self] = newValue
        }
    }
}
