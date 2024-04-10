//
//  SelectedListValue.swift
//  Vocablo
//
//  Created by Marcel Jäger on 10.04.24.
//

import Foundation
import SwiftUI

struct SelectedListValueKey: EnvironmentKey {
    static var defaultValue: ListSelectingValue = .all
}

extension EnvironmentValues {
    var selectedListValue: ListSelectingValue {
        get {
            self[SelectedListValueKey.self]
        }
        set {
            self[SelectedListValueKey.self] = newValue
        }
    }
}
