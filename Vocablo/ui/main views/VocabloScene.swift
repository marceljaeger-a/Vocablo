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
    
    @Environment(\.actionReactingService) private var actionPublisherService
    @Environment(\.selections) private var selections: SelectionContext
    @Environment(\.modelContext) private var context: ModelContext
    @State private var learningList: VocabularyList?
    
    //MARK: - Methodes
    
    private func addNewList() {
        let newList = context.addList("New List")
        actionPublisherService.send(action: \.addingList, input: newList)
    }
    
    private func addNewVocabulary() {
        let newVocabulary = Vocabulary(baseWord: "", translationWord: "", wordGroup: .noun)
        
        if let firstSelectedList: VocabularyList =  context.fetch(by: selections.selectedListIdentifiers).first {
            firstSelectedList.addVocabulary(newVocabulary)
        }else {
            context.insert(newVocabulary)
        }
        
        try? context.save()
        
        actionPublisherService.send(action: \.addingVocabulary, input: newVocabulary)
    }
    
    //MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            ContentView(learningList: $learningList)
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
                addNewList()
            }
            .keyboardShortcut(KeyEquivalent("n"), modifiers: .command.union(.option))
            
            Button("Add vocabulary") {
                addNewVocabulary()
            }
            .keyboardShortcut(KeyEquivalent("n"), modifiers: .command)
        }
    }
    
    var editMenu: some Commands {
        CommandGroup(after: .pasteboard) {
            Divider()
            
            CommandWordGroupPicker(vocabularies: context.fetch(by: selections.selectedVocabularyIdentifiers))
                .disabled(selections.selectedVocabularyIdentifiers.isEmpty)
            
            Divider()
            
            if let firstList: VocabularyList = context.fetch(by: selections.selectedListIdentifiers).first{
                @Bindable var bindedList = firstList
                
                Picker("List sort by", selection: $bindedList.sorting) {
                    VocabularyList.VocabularySorting.pickerContent
                }
                .disabled(selections.selectedListIdentifiers.count != 1)
            }else {
                Menu("List sort by") {
                    
                }
                .disabled(selections.selectedListIdentifiers.count != 1)
            }
        }
    }
    
    var learningMenu: some Commands {
        CommandMenu("Learning") {
            Button("Start learning") {
                if let firstList: VocabularyList = context.fetch(by: selections.selectedListIdentifiers).first {
                    self.learningList = firstList
                }
            }
            .disabled(selections.selectedListIdentifiers.count != 1)
            
            Divider()
            
            Button("To learn"){
                context.checkToLearn(of: context.fetch(by: selections.selectedVocabularyIdentifiers))
            }
            .keyboardShortcut(KeyEquivalent("l"), modifiers: .command)
            .disabled(selections.selectedVocabularyIdentifiers.isEmpty)
            
            Button("Not to learn"){
                context.uncheckToLearn(of: context.fetch(by: selections.selectedVocabularyIdentifiers))
            }
            .keyboardShortcut(KeyEquivalent("l"), modifiers: .command.union(.shift))
            .disabled(selections.selectedVocabularyIdentifiers.isEmpty)
            
            Divider()
            
            Button("Reset lists") {
                let selectedLists: Array<VocabularyList> = context.fetch(by: selections.selectedListIdentifiers)
                context.resetLearningStates(of: selectedLists)
            }
            .disabled(selections.selectedListIdentifiers.isEmpty)
            
            Button("Reset vocabularies") {
                let selectedVocabularies: Array<Vocabulary> = context.fetch(by: selections.selectedVocabularyIdentifiers)
                context.resetLearningStates(of: selectedVocabularies)
            }
            .disabled(selections.selectedVocabularyIdentifiers.isEmpty)
        }
    }
}
