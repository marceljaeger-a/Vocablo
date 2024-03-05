//
//  SelectedVocabulariesFocusedValueKey.swift
//  Vocablo
//
//  Created by Marcel Jäger on 05.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct SelectedVocabulariesFocusedValue: FocusedValueKey {
    typealias Value = Binding<Set<PersistentIdentifier>>
}

extension FocusedValues {
    var selectedVocabularies: Binding<Set<PersistentIdentifier>>? {
        get {
            self[SelectedVocabulariesFocusedValue.self]
        }
        set {
            self[SelectedVocabulariesFocusedValue.self] = newValue
        }
    }
}
