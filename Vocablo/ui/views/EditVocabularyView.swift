//
//  EditVocabularyView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 01.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct EditVocabularyView: View {
    
    //MARK: - Dependencies
    
    @Bindable var vocabulary: Vocabulary
    
    @Environment(\.dismiss) var dismissAction
    @FocusState var focusedTextField: FocusedTextField?
    
    //MARK: - Methods
    
    
    
    //MARK: - Body
    
    var body: some View {
        Form {
            Section {
                TextField("", text: $vocabulary.baseWord, prompt: Text("Word..."))
                    .focused($focusedTextField, equals: .baseWord)
                    .onAppear(perform: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            focusedTextField = .baseWord
                        }
                        
                    })
                TextField("", text: $vocabulary.translationWord, prompt: Text("Translated word..."))
                    .focused($focusedTextField, equals: .translationWord)
            }
            
            Section {
                TextField("", text: $vocabulary.baseSentence, prompt: Text("Sentence..."))
                    .focused($focusedTextField, equals: .baseSentence)
                TextField("", text: $vocabulary.translationSentence, prompt: Text("Translated sentence..."))
                    .focused($focusedTextField, equals: .translationSentence)
            }
            
            Section {
                WordGroupPicker(title: "Word group", group: $vocabulary.wordGroup)
                Toggle("To learn", isOn: $vocabulary.isToLearn)
            }
            
            Section {
                LearningLevelPicker(title: "Level", level: $vocabulary.baseState.level)
                Text("Next repetition in \(vocabulary.baseState.remainingTimeLabel)")
                LastRepetitionDatePicker(state: $vocabulary.baseState)
            }header: {
                HStack {
                    #warning("Implement languages to list.")
                    Text("Word to Translation")
                    Spacer()
                    ResetLearningStateButton(state: $vocabulary.baseState)
                        .buttonStyle(.plain)
                }
            }
            
            Section {
                LearningLevelPicker(title: "Level", level: $vocabulary.translationState.level)
                Text("Next repetition in \(vocabulary.translationState.remainingTimeLabel)")
                LastRepetitionDatePicker(state: $vocabulary.translationState)
            }header: {
                HStack {
                    Text("Translation to Word")
                    Spacer()
                    ResetLearningStateButton(state: $vocabulary.translationState)
                        .buttonStyle(.plain)
                }
            }
        }
        .toolbar {
            Button{
                dismissAction.callAsFunction()
            } label: {
                Text("Done")
            }
            .buttonStyle(.borderedProminent)
        }
        .formStyle(.grouped)
    }
}
