//
//  SidebarMenuCommands.swift
//  Vocablo
//
//  Created by Marcel Jäger on 29.02.24.
//

import Foundation
import SwiftUI
import SwiftData

struct LearningCommands: Commands {
    let modelContext: ModelContext
    
    @FocusedBinding(\.selectedList) var selectedListValue
    @FocusedValue(\.learningValue) var currentLearningValue
    @FocusedBinding(\.isAnswerVisible) var isAnswerVisible
    
    var isShowAnswerButtonDisabled: Bool {
        isAnswerVisible == nil || isAnswerVisible == true
    }
    
    var isAnswerButtonDisabled: Bool {
        if currentLearningValue == nil {
            return true
        }
        
        if isAnswerVisible == false || isAnswerVisible == nil {
            return true
        }
        return false
    }
    
    var body: some Commands {
        CommandMenu("Learning") {
            LearnVocabulariesButton(selectedListValue: selectedListValue, title: "Learn vocabularies")
                .keyboardShortcut(KeyEquivalent("l"), modifiers: .command.union(.option))
            
            Divider()
            
            Button("Show answer"){
                withAnimation {
                    isAnswerVisible = true
                }
            }
            .keyboardShortcut(KeyEquivalent("a"), modifiers: .command)
            .disabled(isShowAnswerButtonDisabled)
            
            Button("Answer true") {
                currentLearningValue?.answerTrue()
            }
            .keyboardShortcut(KeyEquivalent("t"), modifiers: .command)
            .disabled(isAnswerButtonDisabled)
            
            Button("Answer false") {
                currentLearningValue?.answerFalse()
            }
            .keyboardShortcut(KeyEquivalent("f"), modifiers: .command)
            .disabled(isAnswerButtonDisabled)
        }
    }
}
