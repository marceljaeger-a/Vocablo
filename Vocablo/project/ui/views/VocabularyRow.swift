//
//  VocabularyView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 29.02.24.
//

import Foundation
import SwiftUI
import SwiftData

struct VocabularyRow: View {
    
    //MARK: - Dependencies
    
    @Bindable var vocabulary: Vocabulary
    @FocusState.Binding var focusedTextField: FocusedVocabularyTextField?
    let isSelected: Bool
    
    //MARK: - Body
    
    var body: some View {
        Grid(alignment: .leading ,horizontalSpacing: 25, verticalSpacing: 5){
            GridRow {
                DynamicTextField(text: $vocabulary.baseWord, placeholder: "Word...", isTextFieldShown: isSelected, textFieldFocus: $focusedTextField, textFieldFocusValue: .baseWord(vocabularyIdentifier: vocabulary.id))
                DynamicTextField(text: $vocabulary.translationWord, placeholder: "Translated word...", isTextFieldShown: isSelected, textFieldFocus: $focusedTextField, textFieldFocusValue: .translationWord(vocabularyIdentifier: vocabulary.id))
            }
            .font(.headline)
            
            GridRow {
                DynamicTextField(text: $vocabulary.baseSentence, placeholder: "Sentence...", isTextFieldShown: isSelected, textFieldFocus: $focusedTextField, textFieldFocusValue: .baseSentence(vocabularyIdentifier: vocabulary.id))
                DynamicTextField(text: $vocabulary.translationWord, placeholder: "Translated sentence...", isTextFieldShown: isSelected, textFieldFocus: $focusedTextField, textFieldFocusValue: .translationWord(vocabularyIdentifier: vocabulary.id))
            }
            
            GridRow {
                VocabularyInfoGridRowContent(vocabulary: vocabulary)
                    .gridCellColumns(2)
            }
        }
        .textFieldStyle(.plain)
        .padding(5)
    }
}



extension VocabularyRow {
    struct DynamicTextField: View {
        @Binding var text: String
        let placeholder: String
        let isTextFieldShown: Bool
        @FocusState.Binding var textFieldFocus: FocusedVocabularyTextField?
        let textFieldFocusValue: FocusedVocabularyTextField
        
        var currentText: String {
            if text.isEmpty {
                return placeholder
            }
            return text
        }
        
        var body: some View {
            if isTextFieldShown {
                TextField("", text: $text, prompt: Text(placeholder))
                    .focused($textFieldFocus, equals: textFieldFocusValue)
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
    
    var list: VocabularyList? {
        vocabulary.list
    }
    
    var body: some View {
        HStack(spacing: 20) {
            if vocabulary.isToLearn {
                Label("To learn", systemImage: "checkmark")
                    .labelStyle(.titleOnly)
                    .foregroundStyle(.tertiary)
            }
            
            if let list {
                Label(list.name, systemImage: "")
                    .labelStyle(.titleOnly)
                    .foregroundStyle(.tertiary)
            }
            
            Spacer()
        }
    }
}
