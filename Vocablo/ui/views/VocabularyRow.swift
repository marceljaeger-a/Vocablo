//
//  VocabularyView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 29.02.24.
//

import Foundation
import SwiftUI
import SwiftData

enum FocusedTextField: Hashable {
    case baseWord
    case translationWord
    case baseSentence
    case translationSentence
}

struct VocabularyRow: View {
    
    //MARK: - Dependencies
    
    @Bindable var vocabulary: Vocabulary
    let isSelected: Bool
    
    @FocusState var focusedTextField: FocusedTextField?
    
    //MARK: - Body
    
    var body: some View {
        let _ = Self._printChanges()
        Grid(alignment: .leading ,horizontalSpacing: 25, verticalSpacing: 5){
            GridRow {
                DynamicTextField(text: $vocabulary.baseWord, placeholder: "Word...", isTextFieldShown: isSelected, textFieldFocus: $focusedTextField, focusValue: .baseWord)
                DynamicTextField(text: $vocabulary.translationWord, placeholder: "Translated word...", isTextFieldShown: isSelected, textFieldFocus: $focusedTextField, focusValue: .translationWord)
            }
            .font(.headline)
            
            GridRow {
                DynamicTextField(text: $vocabulary.baseSentence, placeholder: "Sentence...", isTextFieldShown: isSelected, textFieldFocus: $focusedTextField, focusValue: .baseSentence)
                DynamicTextField(text: $vocabulary.translationSentence, placeholder: "Translated sentence...", isTextFieldShown: isSelected, textFieldFocus: $focusedTextField, focusValue: .translationSentence)
            }
            
            VocabularyInfoGridRowContent(vocabulary: vocabulary, isSelected: isSelected)
        }
        .textFieldStyle(.plain)
        .padding(5)
        .onChange(of: isSelected) {
            if isSelected {
                focusedTextField = .baseWord
            }
        }
    }
}



extension VocabularyRow {
    struct DynamicTextField: View {
        @Binding var text: String
        let placeholder: String
        let isTextFieldShown: Bool
        @FocusState.Binding var textFieldFocus: FocusedTextField?
        let focusValue: FocusedTextField
        
        var currentText: String {
            if text.isEmpty {
                return placeholder
            }
            return text
        }
        
        var body: some View {
            if isTextFieldShown {
                TextField("", text: $text, prompt: Text(placeholder))
                    .focused($textFieldFocus, equals: focusValue)
            }else {
                HStack {
                    Text(currentText)
                        .foregroundStyle(text.isEmpty ? .tertiary : .primary)
                    Spacer()
                }
            }
        }
    }
    
    
}


struct VocabularyInfoGridRowContent: View {
    let vocabulary: Vocabulary
    let isSelected: Bool
    
    @Environment(\.selectedListValue) var selectedListValue: ListSelectingValue
    
    var listOfVocabulary: VocabularyList? {
        vocabulary.list
    }
    
    var isListNameLabelVisible: Bool {
        if case ListSelectingValue.all = selectedListValue {
            return true
        }
        return false
    }
    
    var body: some View {
        HStack(spacing: 20){
            if vocabulary.isToLearn {
                Label("To learn", systemImage: "checkmark")
                    .labelStyle(.titleOnly)
                    .foregroundStyle(isSelected ? AnyShapeStyle(.primary) : AnyShapeStyle(Color.accentColor.secondary))
            }
            
            if let listOfVocabulary, isListNameLabelVisible == true {
                Label(listOfVocabulary.name, systemImage: "")
                    .labelStyle(.titleOnly)
                    .foregroundStyle(.tertiary)
            }
            
            Spacer()
        }
    }
}
