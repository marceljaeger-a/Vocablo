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
            
            LearningStateSection(header: "Learning state of '\(editingVocabulary.baseWord)'", state: $editingVocabulary.baseState)
            
            LearningStateSection(header: "Learning state of '\(editingVocabulary.translationWord)'", state: $editingVocabulary.translationState)
        }
        .formStyle(.grouped)
        .frame(width: 600)
    }
}



//MARK: - Subviews

extension EditVocabularyView {
    var wordsSection: some View {
        Section {
            VocabularyTextField(vocabulary: editingVocabulary, value: \.baseWord, placeholder: "Word...")
            
            VocabularyTextField(vocabulary: editingVocabulary, value: \.translationWord, placeholder: "Translated word...")
        }
    }
    
    var sentencesSection: some View {
        Section {
            VocabularyTextField(vocabulary: editingVocabulary, value: \.baseSentence, placeholder: "Sentence...")
            
            VocabularyTextField(vocabulary: editingVocabulary, value: \.translationSentence, placeholder: "Translated sentence...")
        }
    }
    
    var explenationSection: some View {
        Section {
            VocabularyTextField(vocabulary: editingVocabulary, value: \.baseExplenation, placeholder: "Explenation...")
            VocabularyTextField(vocabulary: editingVocabulary, value: \.translationExplanation, placeholder: "Translated explenation...")
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
        
        @State private var isResetLearningStateConfirmationDialogShowed = false
        
        var body: some View {
            Section {
                HStack {
                    LearningLevelPicker(level: $state.level)
                    
                    Divider()
                    
                    Button {
                        isResetLearningStateConfirmationDialogShowed = true
                    } label: {
                        Text("Reset")
                    }
                    .confirmationDialog("Do you really want to reset the learning state?", isPresented: $isResetLearningStateConfirmationDialogShowed, actions: {
                        ResetLearningStateConfirmationDialogButtons(isAlertShowed: $isResetLearningStateConfirmationDialogShowed, state: $state)
                    })
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
    
    struct ResetLearningStateConfirmationDialogButtons: View {
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
    EditVocabularyView(editingVocabulary: Vocabulary.init(baseWord: "the tree", translationWord: "der Baum", wordGroup: .noun))
}
