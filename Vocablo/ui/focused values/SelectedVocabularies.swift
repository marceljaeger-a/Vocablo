//
//  SelectedVocabulariesFocusedValueKey.swift
//  Vocablo
//
//  Created by Marcel Jäger on 05.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct SelectedVocabulariesKey: FocusedValueKey {
    typealias Value = Binding<Set<Vocabulary>>
}

extension FocusedValues {
    var selectedVocabularies: Binding<Set<Vocabulary>>? {
        get {
            self[SelectedVocabulariesKey.self]
        }
        set {
            self[SelectedVocabulariesKey.self] = newValue
        }
    }
}
