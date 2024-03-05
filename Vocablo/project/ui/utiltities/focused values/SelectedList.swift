//
//  SelectedListFocusedValueKey.swift
//  Vocablo
//
//  Created by Marcel Jäger on 05.03.24.
//

import Foundation
import SwiftUI


struct SelectedListFocusedValueKey: FocusedValueKey {
    typealias Value = Binding<ListSelectingValue>
}

extension FocusedValues {
    var selectedList: Binding<ListSelectingValue>? {
        get {
            self[SelectedListFocusedValueKey.self]
        }
        set {
            self[SelectedListFocusedValueKey.self] = newValue
        }
    }
}
