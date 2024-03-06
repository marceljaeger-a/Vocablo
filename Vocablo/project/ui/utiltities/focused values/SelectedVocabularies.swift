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
    typealias Value = Binding<Set<Vocabulary>>
}

extension FocusedValues {
    var selectedVocabularies: Binding<Set<Vocabulary>>? {
        get {
            self[SelectedVocabulariesFocusedValue.self]
        }
        set {
            self[SelectedVocabulariesFocusedValue.self] = newValue
        }
    }
}
