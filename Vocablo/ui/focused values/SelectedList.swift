//
//  SelectedListFocusedValueKey.swift
//  Vocablo
//
//  Created by Marcel Jäger on 05.03.24.
//

import Foundation
import SwiftUI


struct SelectedListKey: FocusedValueKey {
    typealias Value = Binding<ListSelectingValue>
}

extension FocusedValues {
    var selectedList: Binding<ListSelectingValue>? {
        get {
            self[SelectedListKey.self]
        }
        set {
            self[SelectedListKey.self] = newValue
        }
    }
}
