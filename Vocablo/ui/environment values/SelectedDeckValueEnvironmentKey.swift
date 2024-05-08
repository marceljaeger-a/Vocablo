//
//  SelectedListValue.swift
//  Vocablo
//
//  Created by Marcel Jäger on 10.04.24.
//

import Foundation
import SwiftUI

struct SelectedDeckValueEnvrionmentKey: EnvironmentKey {
    static var defaultValue: DeckSelectingValue = .all
}

extension EnvironmentValues {
    var selectedDeckValue: DeckSelectingValue {
        get {
            self[SelectedDeckValueEnvrionmentKey.self]
        }
        set {
            self[SelectedDeckValueEnvrionmentKey.self] = newValue
        }
    }
}
