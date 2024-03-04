//
//  FocusValues.swift
//  Vocablo
//
//  Created by Marcel Jäger on 01.03.24.
//

import Foundation
import SwiftUI
import SwiftData

//MARK: - SelectedVocabulariesFocusedValue

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

//MARK: - SelectedListFocusedValue

struct SelectedListFocussedValue: FocusedValueKey {
    typealias Value = Binding<ListSelectingValue>
}

extension FocusedValues {
    var selectedList: Binding<ListSelectingValue>? {
        get {
            self[SelectedListFocussedValue.self]
        }
        set {
            self[SelectedListFocussedValue.self] = newValue
        }
    }
}
