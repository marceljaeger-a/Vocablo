//
//  OnAddingVocabularySubject.swift
//  Vocablo
//
//  Created by Marcel Jäger on 19.03.24.
//

import Foundation
import SwiftUI
import Combine

struct OnAddingVocabularySubjectKey: EnvironmentKey {
    static let defaultValue: PassthroughSubject<Vocabulary, Never> = .init()
}

extension EnvironmentValues {
    var onAddingVocabularySubject: OnAddingVocabularySubjectKey.Value {
        self[OnAddingVocabularySubjectKey.self]
    }
}
