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
            
            LearningStateSection(header: "Learning settings of translating the base word", state: $editingVocabulary.baseState)
            
            LearningStateSection(header: "Learning settings of translating the translated word", state: $editingVocabulary.translationState)
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
                
                LearningLevelPicker(level: $state.level)

                Text("Next repetition in \(state.remainingTimeLabel)")
                
                LastRepetitionDatePicker(state: $state)
            }header: {
                HStack {
                    Text(header)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Button {
                        isResetLearningStateConfirmationDialogShowed = true
                    } label: {
                        Text("Reset")
                    }
                    .buttonStyle(.plain)
                    .confirmationDialog("Do you really want to reset the learning states?", isPresented: $isResetLearningStateConfirmationDialogShowed, actions: {
                        ResetLearningStateConfirmationDialogButtons(isAlertShowed: $isResetLearningStateConfirmationDialogShowed, state: $state)
                    })
                }
                
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
    
    struct LastRepetitionDatePicker: View {
        @Binding var state: LearningState
        
        var body: some View {
            if state.isNewly == false {
                var bindedLastRepetition: Binding<Date> {
                    Binding {
                        state.lastRepetition!
                    } set: { newDate in
                        state.lastRepetition = newDate
                    }
                    
                }
                
                DatePicker("Last repetition", selection: bindedLastRepetition)
                    .datePickerStyle(.stepperField)
                
            }else {
                HStack {
                    Text("Last repetition")
                    
                    Spacer()
                    
                    Button {
                        state.lastRepetition = .now
                    } label: {
                        Text("Set")
                    }
                }
            }
        }
    }
}



//MARK: - Preview

#Preview {
    EditVocabularyView(editingVocabulary: Vocabulary.init(baseWord: "the tree", translationWord: "der Baum", wordGroup: .noun))
}
