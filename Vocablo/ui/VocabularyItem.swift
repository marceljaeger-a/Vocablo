//
//  VocabularyItem.swift
//  Vocablo
//
//  Created by Marcel Jäger on 14.12.23.
//

import Foundation
import SwiftUI
import SwiftData

struct VocabularyItem: View {
    @Bindable var vocabulary: Vocabulary
    @FocusState.Binding var textFieldFocus: VocabularyTextFieldFocusState?
    
    @State var showLearningStateInfoButton: Bool = false
    var learningStateInfoButtonOpacity: Double {
        if showLearningStateInfoButton {
            return 1
        }else {
            return 0
        }
    }
    
    var body: some View {
        HStack(spacing: 20){
            VocabularyToggle(vocabulary: vocabulary, value: \.isLearnable)
                .toggleStyle(.checkbox)

            VStack(alignment: .leading){
                VocabularyTextField(vocabulary: vocabulary, value: \.word, placeholder: "Word...")
                    .focused($textFieldFocus, equals: VocabularyTextFieldFocusState.word(vocabulary.id))
                
                VocabularyTextField(vocabulary: vocabulary, value: \.sentence, placeholder: "Sentence...")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .focused($textFieldFocus, equals: VocabularyTextFieldFocusState.sentence(vocabulary.id))
            }
            
            Divider()
            
            VStack(alignment: .leading){
                VocabularyTextField(vocabulary: vocabulary, value: \.translatedWord, placeholder: "Translated word..")
                    .focused($textFieldFocus, equals: VocabularyTextFieldFocusState.translatedWord(vocabulary.id))
                
                VocabularyTextField(vocabulary: vocabulary, value: \.translatedSentence, placeholder: "Translated sentence..")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .focused($textFieldFocus, equals: VocabularyTextFieldFocusState.translatedSentenced(vocabulary.id))
            }
            
            LearningStateInfoButton(vocabulary: vocabulary)
                .buttonStyle(.borderless)
                .foregroundStyle(.secondary)
                .opacity(learningStateInfoButtonOpacity)
        }
        .padding(6)
        .textFieldStyle(.plain)
        .autocorrectionDisabled(true)
        .onHover{ hovering in
            withAnimation(.easeInOut) {
                showLearningStateInfoButton = hovering
            }
        }
    }
}

enum VocabularyTextFieldFocusState: Hashable{
    case word(PersistentIdentifier), translatedWord(PersistentIdentifier), sentence(PersistentIdentifier), translatedSentenced(PersistentIdentifier)
}
