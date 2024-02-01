//
//  VocabularyItem.swift
//  Vocablo
//
//  Created by Marcel Jäger on 14.12.23.
//

import Foundation
import SwiftUI
import SwiftData


//MARK: - Types

enum VocabularyTextFieldFocusState: Hashable{
    case word(PersistentIdentifier), translatedWord(PersistentIdentifier), sentence(PersistentIdentifier), translatedSentenced(PersistentIdentifier)
}



struct VocabularyItem: View {
    
    //MARK: - Properties
    
    @Bindable var vocabulary: Vocabulary
    @FocusState.Binding var textFieldFocus: VocabularyTextFieldFocusState?
    let isDuplicateRecognitionLabelAvailable: Bool
    let isListLabelAvailable: Bool
    
    @Query var allVocabularies: Array<Vocabulary>
    @State private var isLearningStateInfoButtonShowed: Bool = false
    
    private var learningStateInfoButtonOpacity: Double {
        if isLearningStateInfoButtonShowed {
            return 1
        }else {
            return 0
        }
    }
    
    let duplicateRecognicer = DuplicateRecognitionService()
    
    //MARK: - Body
    
    var body: some View {
        HStack(spacing: 20){
            VocabularyToggle(vocabulary: vocabulary, value: \.isToLearn)
                .toggleStyle(.checkbox)
            
            VStack(spacing: 10){
                HStack {
                    wordAndSentenceVStack
                    
                    Divider()
                    
                    translatedWordAndSentenceVStack
                }
                
                if isDuplicateRecognitionLabelAvailable || isListLabelAvailable{
                    HStack(spacing: 20){
                        if isListLabelAvailable, let list = vocabulary.list {
                            VocabularyListLabel(list: list)
                        }
                        if duplicateRecognicer.existDuplicate(of: vocabulary, within: allVocabularies) {
                            DuplicateVocabulariesPopoverButton(duplicatesOf: vocabulary, within: allVocabularies)
                                .buttonStyle(.plain)
                            
                            
                        }
                        Spacer()
                    }
                }
            }
            
            LearningStateInfoButton(vocabulary: vocabulary)
                .buttonStyle(.borderless)
                .foregroundStyle(.secondary)
                .opacity(learningStateInfoButtonOpacity)
        }
        .padding(6)
        .textFieldStyle(.plain)
        .autocorrectionDisabled(true)
        .onHover{ isHovering in
            withAnimation(.easeInOut) {
                isLearningStateInfoButtonShowed = isHovering
            }
        }
    }
}



//MARK: - Subviews

extension VocabularyItem {
    var wordAndSentenceVStack: some View {
        VStack(alignment: .leading){
            VocabularyTextField(vocabulary: vocabulary, value: \.baseWord, placeholder: "Word...")
                .font(.headline)
                .focused($textFieldFocus, equals: VocabularyTextFieldFocusState.word(vocabulary.id))
            
            VocabularyTextField(vocabulary: vocabulary, value: \.baseSentence, placeholder: "Sentence...")
                .foregroundStyle(.secondary)
                .focused($textFieldFocus, equals: VocabularyTextFieldFocusState.sentence(vocabulary.id))
        }
    }
    
    var translatedWordAndSentenceVStack: some View {
        VStack(alignment: .leading){
            VocabularyTextField(vocabulary: vocabulary, value: \.translationWord, placeholder: "Translated word..")
                .font(.headline)
                .focused($textFieldFocus, equals: VocabularyTextFieldFocusState.translatedWord(vocabulary.id))
            
            VocabularyTextField(vocabulary: vocabulary, value: \.translationSentence, placeholder: "Translated sentence..")
                .foregroundStyle(.secondary)
                .focused($textFieldFocus, equals: VocabularyTextFieldFocusState.translatedSentenced(vocabulary.id))
        }
    }
}