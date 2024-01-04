//
//  VocabloScene.swift
//  Vocablo
//
//  Created by Marcel Jäger on 09.12.23.
//

import Foundation
import SwiftUI
import SwiftData
import Combine

struct VocabloScene: Scene {
    
    //MARK: - Properties
    
    @Binding var isWelcomeSheetShowed: Bool
    
    @Environment(\.modelContext) private var context: ModelContext
    @State private var selectedListIdentifiers: Set<PersistentIdentifier> = []
    @State private var selectedVocabularyIdentifiers: Set<PersistentIdentifier> = []
    @State private var learningList: VocabularyList?
    
    //MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            ContentView(selectedListIdentifiers: $selectedListIdentifiers, selectedVocabularyIdentifiers: $selectedVocabularyIdentifiers, learningList: $learningList)
                .sheet(isPresented: $isWelcomeSheetShowed) {
                    WelcomeSheet(isShowing: $isWelcomeSheetShowed)
                }
                .sheet(item: $learningList) {
                    
                } content: { learningList in
                    LearningSheet(list: learningList)
                }

        }
        .defaultSize(width: 1280, height: 720)
        .commands {
            fileMenu
            editMenu
            learningMenu
        }
    }
}



//MARK: - Commands
extension VocabloScene {
    var fileMenu: some Commands {
        CommandGroup(replacing: .newItem) {
            Button("Add list") {
                context.addList("New list")
            }
            .keyboardShortcut(KeyEquivalent("n"), modifiers: .command.union(.option))
            
            Button("Add vocabulary") {
                guard let firstSelectedList: VocabularyList =  context.fetch(by: selectedListIdentifiers).first else { return }
                firstSelectedList.addNewVocabulary()
            }
            .keyboardShortcut(KeyEquivalent("n"), modifiers: .command)
            .disabled(selectedListIdentifiers.isEmpty)
        }
    }
    
    var editMenu: some Commands {
        CommandGroup(after: .pasteboard) {
            Divider()
            
            CommandWordGroupPicker(vocabularies: context.fetch(by: selectedVocabularyIdentifiers))
                .disabled(selectedVocabularyIdentifiers.isEmpty)
            
            Divider()
            
            if let firstList: VocabularyList = context.fetch(by: selectedListIdentifiers).first{
                @Bindable var bindedList = firstList
                
                Picker("List sort by", selection: $bindedList.sorting) {
                    VocabularyList.VocabularySorting.pickerContent
                }
                .disabled(selectedListIdentifiers.count != 1)
            }else {
                Menu("List sort by") {
                    
                }
                .disabled(selectedListIdentifiers.count != 1)
            }
        }
    }
    
    var learningMenu: some Commands {
        CommandMenu("Learning") {
            Button("Start learning") {
                if let firstList: VocabularyList = context.fetch(by: selectedListIdentifiers).first {
                    self.learningList = firstList
                }
            }
            .disabled(selectedListIdentifiers.count != 1)
            
            Divider()
            
            Button("To learn"){
                context.checkToLearn(of: context.fetch(by: selectedVocabularyIdentifiers))
            }
            .keyboardShortcut(KeyEquivalent("l"), modifiers: .command)
            .disabled(selectedVocabularyIdentifiers.isEmpty)
            
            Button("Not to learn"){
                context.uncheckToLearn(of: context.fetch(by: selectedVocabularyIdentifiers))
            }
            .keyboardShortcut(KeyEquivalent("l"), modifiers: .command.union(.shift))
            .disabled(selectedVocabularyIdentifiers.isEmpty)
            
            Divider()
            
            Button("Reset lists") {
                let selectedLists: Array<VocabularyList> = context.fetch(by: selectedListIdentifiers)
                context.resetLearningStates(of: selectedLists)
            }
            .disabled(selectedListIdentifiers.isEmpty)
            
            Button("Reset vocabularies") {
                let selectedVocabularies: Array<Vocabulary> = context.fetch(by: selectedVocabularyIdentifiers)
                context.resetLearningStates(of: selectedVocabularies)
            }
            .disabled(selectedVocabularyIdentifiers.isEmpty)
        }
    }
}
