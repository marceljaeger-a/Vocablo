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
    @Environment(\.selectionContext) private var selectionContext: SelectionContext
    @Environment(\.modelContext) private var modelContext: ModelContext
    @State private var learningList: VocabularyList?
    
    //MARK: - Methodes
    
    private func addNewList() {
        let newList = modelContext.addList("New List")
        actionPublisherService.send(action: \.addingList, input: newList)
    }
    
    private func addNewVocabulary() {
        let newVocabulary = Vocabulary(baseWord: "", translationWord: "", wordGroup: .noun)
        
        if let firstSelectedList: VocabularyList =  modelContext.fetch(by: selectionContext.selectedListIdentifiers).first {
            firstSelectedList.addVocabulary(newVocabulary)
        }else {
            modelContext.insert(newVocabulary)
        }
        
        try? modelContext.save()
        
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
            
            CommandWordGroupPicker(vocabularies: modelContext.fetch(by: selectionContext.selectedVocabularyIdentifiers))
                .disabled(selectionContext.selectedVocabularyIdentifiers.isEmpty)
            
            Divider()
            
            if let firstList: VocabularyList = modelContext.fetch(by: selectionContext.selectedListIdentifiers).first{
                @Bindable var bindedList = firstList
                
                Picker("List sort by", selection: $bindedList.sorting) {
                    VocabularyList.VocabularySorting.pickerContent
                }
                .disabled(selectionContext.selectedListIdentifiers.count != 1)
            }else {
                Menu("List sort by") {
                    
                }
                .disabled(selectionContext.selectedListIdentifiers.count != 1)
            }
        }
    }
    
    var learningMenu: some Commands {
        CommandMenu("Learning") {
            Button("Start learning") {
                if let firstList: VocabularyList = modelContext.fetch(by: selectionContext.selectedListIdentifiers).first {
                    self.learningList = firstList
                }
            }
            .disabled(selectionContext.selectedListIdentifiers.count != 1)
            
            Divider()
            
            Button("To learn"){
                modelContext.checkToLearn(of: modelContext.fetch(by: selectionContext.selectedVocabularyIdentifiers))
            }
            .keyboardShortcut(KeyEquivalent("l"), modifiers: .command)
            .disabled(selectionContext.selectedVocabularyIdentifiers.isEmpty)
            
            Button("Not to learn"){
                modelContext.uncheckToLearn(of: modelContext.fetch(by: selectionContext.selectedVocabularyIdentifiers))
            }
            .keyboardShortcut(KeyEquivalent("l"), modifiers: .command.union(.shift))
            .disabled(selectionContext.selectedVocabularyIdentifiers.isEmpty)
            
            Divider()
            
            Button("Reset lists") {
                let selectedLists: Array<VocabularyList> = modelContext.fetch(by: selectionContext.selectedListIdentifiers)
                modelContext.resetLearningStates(of: selectedLists)
            }
            .disabled(selectionContext.selectedListIdentifiers.isEmpty)
            
            Button("Reset vocabularies") {
                let selectedVocabularies: Array<Vocabulary> = modelContext.fetch(by: selectionContext.selectedVocabularyIdentifiers)
                modelContext.resetLearningStates(of: selectedVocabularies)
            }
            .disabled(selectionContext.selectedVocabularyIdentifiers.isEmpty)
        }
    }
}
