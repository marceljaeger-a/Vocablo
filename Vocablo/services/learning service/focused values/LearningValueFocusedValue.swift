//
//  FocusedLearningValue.swift
//  Vocablo
//
//  Created by Marcel Jäger on 25.03.24.
//

import Foundation
import SwiftUI

struct LearningValueFocusedValue: FocusedValueKey {
    typealias Value = IndexCard<Vocabulary>
}

extension FocusedValues {
    var learningValue: IndexCard<Vocabulary>? {
        get {
            self[LearningValueFocusedValue.self]
        }
        set {
            self[LearningValueFocusedValue.self] = newValue
        }
    }
}
