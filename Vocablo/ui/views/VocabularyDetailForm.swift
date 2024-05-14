//
//  EditVocabularyForm.swift
//  Vocablo
//
//  Created by Marcel Jäger on 02.05.24.
//

import Foundation
import SwiftUI


struct VocabularyDetailForm: View {
    
    //MARK: - Properties
    
    @Binding var editingVocabulary: Vocabulary?
    var addNewVocabularyToDeck: Optional<(Vocabulary) -> Void> = nil
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.onAddingVocabularySubject) var onAddingVocabularySubject
    @Environment(\.dismiss) var dismissAction
    
    @State var isMoreLearningConfigurationForBaseShown: Bool = false
    
    @State var baseWord: String = ""
    @State var baseSentence: String = ""
    @State var translationWord: String = ""
    @State var translationSentence: String = ""
    @State var isToLearn: Bool = false
    @State var levelOfBase: LearningLevel = .lvl1
    @State var levelOfTranslation: LearningLevel = .lvl1
    
    //MARK: - Methods
    
    private func resetPropertiesOfView() {
        self.baseWord = ""
        self.baseSentence = ""
        self.translationWord = ""
        self.translationSentence = ""
        self.isToLearn = false
        self.levelOfBase = .lvl1
        self.levelOfTranslation = .lvl1
    }
    
    private func setupPropertiesOfView() {
        if let editingVocabulary {
            self.baseWord = editingVocabulary.baseWord
            self.baseSentence = editingVocabulary.baseSentence
            self.translationWord = editingVocabulary.translationWord
            self.translationSentence = editingVocabulary.translationSentence
            self.isToLearn = editingVocabulary.isToLearn
            self.levelOfBase = editingVocabulary.levelOfBase
            self.levelOfTranslation = editingVocabulary.levelOfTranslation
        }
    }
    
    private func updateVocabulary(_ vocabulary: Vocabulary) {
        vocabulary.baseWord = self.baseWord
        vocabulary.baseSentence = self.baseSentence
        vocabulary.translationWord = self.translationWord
        vocabulary.translationSentence = self.translationSentence
        vocabulary.isToLearn = self.isToLearn
        vocabulary.levelOfBase = self.levelOfBase
        vocabulary.levelOfTranslation = self.levelOfTranslation
    }
    
    private func saveAndCreateNewVocabulary() {
        if let editingVocabulary {
            self.updateVocabulary(editingVocabulary)
            self.editingVocabulary = nil
        }else {
            if baseWord.isEmpty && baseSentence.isEmpty && translationWord.isEmpty && translationSentence.isEmpty {
                baseWord = "New vocabulary"
            }
            
            let newVocabulary = Vocabulary(baseWord: self.baseWord, baseSentence: self.baseSentence, translationWord: self.translationWord, translationSentence: self.translationSentence, isToLearn: self.isToLearn, levelOfBase: self.levelOfBase, levelOfTranslation: self.levelOfTranslation, sessionsOfBase: [], sessionsOfTranslation: [], nextSessionOfBase: Date.now, nextSessionOfTranslation: Date.now)
            modelContext.insert(newVocabulary)
            
            onAddingVocabularySubject.send(newVocabulary)
        }
        
        self.resetPropertiesOfView()
    }
    
    private func saveVocabularyAndDismiss() {
        if let editingVocabulary {
            self.updateVocabulary(editingVocabulary)
            self.editingVocabulary = nil
        }else {
            if baseWord.isEmpty && baseSentence.isEmpty && translationWord.isEmpty && translationSentence.isEmpty {
                baseWord = "New vocabulary"
            }
            
            let newVocabulary = Vocabulary(baseWord: self.baseWord, baseSentence: self.baseSentence, translationWord: self.translationWord, translationSentence: self.translationSentence, isToLearn: self.isToLearn, levelOfBase: self.levelOfBase, levelOfTranslation: self.levelOfTranslation, sessionsOfBase: [], sessionsOfTranslation: [], nextSessionOfBase: Date.now, nextSessionOfTranslation: Date.now)
            modelContext.insert(newVocabulary)
            if let addNewVocabularyToDeck {
                addNewVocabularyToDeck(newVocabulary)
            }
            
            onAddingVocabularySubject.send(newVocabulary)
        }
        
        dismissAction()
    }
    
    private func cancelAndDismiss() {
        dismissAction()
    }
    
    //MARK: - Body
    
    var body: some View {
        Form {
            Section {
                TextField("", text: $baseWord, prompt: Text("Word, ..."))
                TextEditor(text: $baseSentence)
                    .font(.body)
                    .lineLimit(1...5)
            }
            
            Section {
                TextField("", text: $translationWord, prompt: Text("Word, ..."))
                TextEditor(text: $translationSentence)
                    .font(.body)
                    .lineLimit(1...5)
            }
            
            Toggle("To learn", isOn: $isToLearn)
            
            Section("More learning configuration", isExpanded: $isMoreLearningConfigurationForBaseShown) {
                #warning("Change the BASE to the LANGUAGE")
                LearningLevelPicker(title: "Level of base", level: $levelOfBase)
                if let editingVocabulary {
                    HStack {
                        Text("Next repetition in ")
                        if editingVocabulary.nextSessionOfBase > Date.now {
                            Text(editingVocabulary.nextSessionOfBase, style: .timer)
                        }else {
                            Text("0:00")
                        }
                    }
                }
                
                #warning("Change the BASE to the LANGUAGE")
                LearningLevelPicker(title: "Level of translation", level: $levelOfTranslation)
                if let editingVocabulary {
                    HStack {
                        Text("Next repetition in ")
                        if editingVocabulary.nextSessionOfTranslation > Date.now {
                            Text(editingVocabulary.nextSessionOfTranslation, style: .timer)
                        }else {
                            Text("0:00")
                        }
                    }
                }
            }
        }
        .formStyle(.grouped)
        .textFieldStyle(.plain)
        .textEditorStyle(.plain)
        .onAppear {
            setupPropertiesOfView()
        }
        .toolbar {
            ToolbarItem {
                Button {
                    saveAndCreateNewVocabulary()
                } label: {
                    Text("Save & New")
                }
            }
            
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    cancelAndDismiss()
                } label: {
                    Text("Cancel")
                }
            }
            
            
            ToolbarItem(placement: .confirmationAction){
                Button {
                    saveVocabularyAndDismiss()
                } label: {
                    Text("Done")
                }
            }
        }
    }
}
