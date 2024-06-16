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
    let currentDeck: Deck?
    
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
    
    var sheetTitle: String {
        return if editingVocabulary == nil {
            "New vocabulary"
        }else {
            "Edit vocabulary"
        }
    }
    
    var titleOfLanguageOfBase: String {
        if let deck = editingVocabulary?.deck {
            if deck.languageOfBase.isEmpty == false {
                return deck.languageOfBase
            }
        }
        return "first content"
    }
    
    var titleOfLanguageOfTranslation: String {
        if let deck = editingVocabulary?.deck  {
            if deck.languageOfTranslation.isEmpty == false {
                return deck.languageOfTranslation
            }
        }
        return "second content"
    }
    
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
            if let currentDeck {
                currentDeck.vocabularies.append(newVocabulary)
            }
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
            if let currentDeck {
                currentDeck.vocabularies.append(newVocabulary)
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
        VStack {
            Text(sheetTitle)
                .font(.title)
                .fontDesign(.rounded)
                .padding()
            
            Form {
                Section(titleOfLanguageOfBase) {
                    TextField("", text: $baseWord, prompt: Text("Word, ..."))
                    TextEditor(text: $baseSentence)
                        .font(.body)
                        .lineLimit(1...5)
                }
                
                Section(titleOfLanguageOfTranslation) {
                    TextField("", text: $translationWord, prompt: Text("Word, ..."))
                    TextEditor(text: $translationSentence)
                        .font(.body)
                        .lineLimit(1...5)
                }
                
                Toggle("To learn", isOn: $isToLearn)
                
                Section("More learning configuration", isExpanded: $isMoreLearningConfigurationForBaseShown) {
                    LearningLevelPicker(title: "Level of \(titleOfLanguageOfBase)", level: $levelOfBase)
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
                    
                    LearningLevelPicker(title: "Level of \(titleOfLanguageOfTranslation)", level: $levelOfTranslation)
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
            .frame(minWidth: 250, maxWidth: 800, minHeight: 250, maxHeight: 800)
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
                    .keyboardShortcut(KeyEquivalent("n"), modifiers: .command)
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
}
