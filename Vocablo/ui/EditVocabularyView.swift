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
    @Bindable var vocabulary: Vocabulary
    @Query(sort: \Tag.name) var tags: Array<Tag>
    
    @State var showLearningStateResetAlert: Bool = false
    @State var showTranslatedLearningStateResetAlert: Bool = false
    
    var body: some View {
        Form {
            Section {
                VocabularyTextField(vocabulary: vocabulary, value: \.word, placeholder: "Word...")
                
                VocabularyTextField(vocabulary: vocabulary, value: \.translatedWord, placeholder: "Translated word...")
            }
            
            Section {
                VocabularyTextField(vocabulary: vocabulary, value: \.sentence, placeholder: "Sentence...")
                
                VocabularyTextField(vocabulary: vocabulary, value: \.translatedSentence, placeholder: "Translated sentence...")
            }
            
//            Section {
//                VocabularyTextField(vocabulary: vocabulary, value: \.explenation, placeholder: "Explenation...")
//                VocabularyTextField(vocabulary: vocabulary, value: \.translatedExplanation, placeholder: "Translated explenation...")
//            }
            
            Section {
                WordGroupPicker(vocabulary: vocabulary)
                
//                TagMultiPicker(vocabulary: vocabulary, tags: tags)
                VocabularyToggle(vocabulary: vocabulary, value: \.isLearnable, label: Text("To learn"))
            }
            
            LearningStateSection(header: "Learning state of '\(vocabulary.word)'", state: $vocabulary.learningState)
            
            LearningStateSection(header: "Learning state of '\(vocabulary.translatedWord)'", state: $vocabulary.translatedLearningState)
        }
        .formStyle(.grouped)
        .frame(width: 600)
    }
}

fileprivate struct LearningStateSection: View {
    let header: String
    @Binding var state: LearningState
    
    @State var showResetAlert = false
    
    var body: some View {
        Section {
            HStack {
                LearningLevelPicker(state: $state)
                
                Divider()
                
                Button {
                    showResetAlert = true
                } label: {
                    Text("Reset")
                }
                .alert("Are you sure to reset the learning state?", isPresented: $showResetAlert) {
                    ResetLearningStateAlertView(showAlert: $showResetAlert, state: $state)
                }
            }
            
            Text("Next repetition in \(state.remainingTimeLabel)")
        }header: {
            HStack {
                Text(header)
                
                Spacer()
                
                InfoPopoverButton()
            }
            .foregroundStyle(.secondary)
        }
    }
}

fileprivate struct ResetLearningStateAlertView: View {
    @Binding var showAlert: Bool
    @Binding var state: LearningState
    
    var body: some View {
        Button(role: .cancel){
            showAlert = false
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

#Preview {
    EditVocabularyView(vocabulary: Vocabulary.init(word: "the tree", translatedWord: "der Baum", wordGroup: .noun))
}
