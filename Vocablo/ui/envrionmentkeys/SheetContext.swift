//
//  EditingVocabulary.swift
//  Vocablo
//
//  Created by Marcel Jäger on 30.01.24.
//

import Foundation
import SwiftUI

@Observable
class SheetContext {
    var editingVocabulary: Vocabulary?
    var learningVocabularies: Array<Vocabulary>?
    var isLearningSheetShown: Bool {
        get {
            learningVocabularies != nil
        }
        set {
            switch newValue {
            case true:
                break
            case false:
                learningVocabularies = nil
            }
        }
    }
    
    var isWelcomeSheetShown: Bool = true
    
    var bindable: Bindable<SheetContext> {
        @Bindable var bindableContext = self
        return _bindableContext
    }
    
}

struct SheetContextEnvironmentKey: EnvironmentKey {
    static var defaultValue: SheetContext = SheetContext()
}

extension EnvironmentValues {
    var sheetContext: SheetContext {
        get {
            return self[SheetContextEnvironmentKey.self]
        }
        set {
            self[SheetContextEnvironmentKey.self] = newValue
        }
    }
}
