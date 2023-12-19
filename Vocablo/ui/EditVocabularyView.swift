//
//  EditVocabularyView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 26.11.23.
//

import Foundation
import SwiftUI
import SwiftData

struct EditVocabularyView: View {
    
    //MARK: - Properties
    
    @Bindable var editingVocabulary: Vocabulary
    
    //MARK: - Body
    
    var body: some View {
        Form {
            wordsSection
            
            sentencesSection
            
            wordGroupAndLearnableSection
            
            LearningStateSection(header: "Learning state of '\(editingVocabulary.word)'", state: $editingVocabulary.learningState)
            
            LearningStateSection(header: "Learning state of '\(editingVocabulary.translatedWord)'", state: $editingVocabulary.translatedLearningState)
        }
        .formStyle(.grouped)
        .frame(width: 600)
    }
}



//MARK: - Subviews

extension EditVocabularyView {
    var wordsSection: some View {
        Section {
            VocabularyTextField(vocabulary: editingVocabulary, value: \.word, placeholder: "Word...")
            
            VocabularyTextField(vocabulary: editingVocabulary, value: \.translatedWord, placeholder: "Translated word...")
        }
    }
    
    var sentencesSection: some View {
        Section {
            VocabularyTextField(vocabulary: editingVocabulary, value: \.sentence, placeholder: "Sentence...")
            
            VocabularyTextField(vocabulary: editingVocabulary, value: \.translatedSentence, placeholder: "Translated sentence...")
        }
    }
    
    var explenationSection: some View {
        Section {
            VocabularyTextField(vocabulary: editingVocabulary, value: \.explenation, placeholder: "Explenation...")
            VocabularyTextField(vocabulary: editingVocabulary, value: \.translatedExplanation, placeholder: "Translated explenation...")
        }
    }
    
    var wordGroupAndLearnableSection: some View {
        Section {
            WordGroupPicker(vocabulary: editingVocabulary)
            
            VocabularyToggle(vocabulary: editingVocabulary, value: \.isToLearn, label: Text("To learn"))
        }
    }
    
    struct LearningStateSection: View {
        let header: String
        @Binding var state: LearningState
        
        @State private var isResetAlertShowed = false
        
        var body: some View {
            Section {
                HStack {
                    LearningLevelPicker(state: $state)
                    
                    Divider()
                    
                    Button {
                        isResetAlertShowed = true
                    } label: {
                        Text("Reset")
                    }
                    .alert("Are you sure to reset the learning state?", isPresented: $isResetAlertShowed) {
                        ResetLearningStateAlertView(isAlertShowed: $isResetAlertShowed, state: $state)
                    }
                }
                
                Text("Next repetition in \(state.remainingTimeLabel)")
            }header: {
                HStack {
                    Text(header)
                    
                    Spacer()
                    
                    LearningStateExplenationPopover()
                }
                .foregroundStyle(.secondary)
            }
        }
    }
    
    struct ResetLearningStateAlertView: View {
        @Binding var isAlertShowed: Bool
        @Binding var state: LearningState
        
        var body: some View {
            Button(role: .cancel){
                isAlertShowed = false
            } label: {
                Text("Cancel")
            }
            
            Button {
                state.reset()
            } label: {
                Text("Reset")
            }
        }
    }
}



//MARK: - Preview

#Preview {
    EditVocabularyView(editingVocabulary: Vocabulary.init(word: "the tree", translatedWord: "der Baum", wordGroup: .noun))
}
