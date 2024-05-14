//
//  EditVocabularyForm.swift
//  Vocablo
//
//  Created by Marcel Jäger on 02.05.24.
//

import Foundation
import SwiftUI


struct EditVocabularyView: View {
    
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
    
    private func saveAndCreateNewVocabulary() {
        if let editingVocabulary {
            editingVocabulary.baseWord = self.baseWord
            editingVocabulary.baseSentence = self.baseSentence
            editingVocabulary.translationWord = self.translationWord
            editingVocabulary.translationSentence = self.translationSentence
            editingVocabulary.isToLearn = self.isToLearn
            editingVocabulary.levelOfBase = self.levelOfBase
            editingVocabulary.levelOfTranslation = self.levelOfTranslation
            
            self.editingVocabulary = nil
        }else {
            let newVocabulary = Vocabulary(baseWord: self.baseWord, baseSentence: self.baseSentence, translationWord: self.translationWord, translationSentence: self.translationSentence, isToLearn: self.isToLearn, levelOfBase: self.levelOfBase, levelOfTranslation: self.levelOfTranslation, sessionsOfBase: [], sessionsOfTranslation: [], nextSessionOfBase: Date.now, nextSessionOfTranslation: Date.now)
            modelContext.insert(newVocabulary)
            onAddingVocabularySubject.send(newVocabulary)
        }
        
        self.baseWord = ""
        self.baseSentence = ""
        self.translationWord = ""
        self.translationSentence = ""
        self.isToLearn = false
        self.levelOfBase = .lvl1
        self.levelOfTranslation = .lvl2
    }
    
    private func saveVocabularyAndDismiss() {
        if let editingVocabulary {
            editingVocabulary.baseWord = self.baseWord
            editingVocabulary.baseSentence = self.baseSentence
            editingVocabulary.translationWord = self.translationWord
            editingVocabulary.translationSentence = self.translationSentence
            editingVocabulary.isToLearn = self.isToLearn
            editingVocabulary.levelOfBase = self.levelOfBase
            editingVocabulary.levelOfTranslation = self.levelOfTranslation
            
            self.editingVocabulary = nil
        }else {
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
