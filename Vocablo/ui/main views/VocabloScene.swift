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
    
    @Environment(\.actionReactingService) private var actionPublisherService
    @Environment(\.selectionContext) private var selectionContext: SelectionContext
    @Environment(\.sheetContext) private var sheetContext
    @Environment(\.modelContext) private var modelContext: ModelContext
    @Query private var allVocabularies: Array<Vocabulary>
    let duplicatesRecognizer = DuplicateRecognitionService()
    
    //MARK: - Methodes
    
    private func addNewList() {
        let newList: VocabularyList = .newList
        modelContext.insert(newList)
        do {
            try modelContext.save()
        } catch {
            print("Saving adding new list failed!")
        }
        actionPublisherService.send(action: \.addingList, input: newList)
    }
    
    private func addNewVocabulary() {
        let newVocabulary: Vocabulary = .newVocabulary
        
        if let selectedListIdentifiers = selectionContext.listSelections.listIdentifiers, let firstSelectedList =  modelContext.fetchLists(.byIdentifiers(selectedListIdentifiers)).first {
            firstSelectedList.append(vocabulary: .newVocabulary)
        }else {
            modelContext.insert(newVocabulary)
        }
        
        try? modelContext.save()
        
        actionPublisherService.send(action: \.addingVocabulary, input: newVocabulary)
    }
    
    //MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .sheet(isPresented: sheetContext.bindable.isWelcomeSheetShown) {
                    WelcomeSheet(isShowing: sheetContext.bindable.isWelcomeSheetShown)
                }
                .sheet(isPresented: sheetContext.bindable.isLearningSheetShown, content: {
                    if let learningVocabularies = sheetContext.learningVocabularies {
                        LearningSheet(learningVocabularies: learningVocabularies)
                    }
                })

        }
        .defaultSize(width: 1280, height: 720)
        .commands {
            fileMenu
            editMenu
            viewMenu
            learningMenu
        }
    }
}



//MARK: - Commands
extension VocabloScene {
    var fileMenu: some Commands {
        CommandGroup(replacing: .newItem) {
            Button("New list") {
                addNewList()
            }
            .keyboardShortcut(KeyEquivalent("n"), modifiers: .command.union(.shift))
            
            Button("New vocabulary") {
                addNewVocabulary()
            }
            .keyboardShortcut(KeyEquivalent("n"), modifiers: .command)
        }
    }
    
    var editMenu: some Commands {
        CommandGroup(after: .pasteboard) {
            Divider()
            
            if selectionContext.selectedVocabularyIdentifiers.isEmpty == false {
                CommandWordGroupPicker(vocabularies: modelContext.fetchVocabularies(.byIdentifiers(selectionContext.selectedVocabularyIdentifiers)))
            }else {
                Text("Set word group of selected vocabularies")
            }
            
            Divider()
            
            Button("Check selected vocabularies for learning"){
                modelContext.fetchVocabularies(.byIdentifiers(selectionContext.selectedVocabularyIdentifiers)).forEach { $0.checkToLearn() }
            }
            .keyboardShortcut(KeyEquivalent("l"), modifiers: .command)
            .disabled(selectionContext.selectedVocabularyIdentifiers.isEmpty)
            
            Button("Uncheck selected vocabularies for learning"){
                modelContext.fetchVocabularies(.byIdentifiers(selectionContext.selectedVocabularyIdentifiers)).forEach { $0.uncheckToLearn() }
            }
            .keyboardShortcut(KeyEquivalent("l"), modifiers: .command.union(.shift))
            .disabled(selectionContext.selectedVocabularyIdentifiers.isEmpty)
            
            Divider()
            
            Button("Reset selected vocabularies") {
                let selectedVocabularies = modelContext.fetchVocabularies(.byIdentifiers(selectionContext.selectedVocabularyIdentifiers))
                selectedVocabularies.forEach { $0.resetLearningsStates() }
            }
            .keyboardShortcut(KeyEquivalent("r"), modifiers: .command)
            .disabled(selectionContext.selectedVocabularyIdentifiers.isEmpty)
            
            Button("Reset vocabularies of shown list") {
                if selectionContext.listSelections.isAllVocabulariesSelected {
                    allVocabularies.forEach { $0.resetLearningsStates() }
                }else if selectionContext.listSelections.isDuplicatesSelected {
                    duplicatesRecognizer.valuesWithDuplicate(within: allVocabularies).forEach { $0.resetLearningsStates() }
                }else if selectionContext.listSelections.isAnyListSelected{
                    guard let listIdentifiers = selectionContext.listSelections.listIdentifiers else { return }
                    guard let firstSelectedList = modelContext.fetchLists(.byIdentifiers(listIdentifiers)).first else { return }
                    firstSelectedList.resetLearningStates()
                }
            }
            .keyboardShortcut(KeyEquivalent("r"), modifiers: .command.union(.shift))
            .disabled(selectionContext.listSelections.isAnySelected == false)

        }
    }
    
    var viewMenu: some Commands {
        CommandGroup(before: .toolbar) {
            if let selectedListIdentifiers = selectionContext.listSelections.listIdentifiers, let firstSelectedList =  modelContext.fetchLists(.byIdentifiers(selectedListIdentifiers)).first{
                @Bindable var bindedList = firstSelectedList
                
                Picker("Sort shown list by", selection: $bindedList.sorting) {
                    VocabularyList.VocabularySorting.pickerContent
                }
            }else {
                Text("Sort shown list by")
            }
            
            Divider()
        }
    }
    
    var learningMenu: some Commands {
        CommandMenu("Learning") {
            Button("Learn shown list") {
                if selectionContext.listSelections.isAllVocabulariesSelected {
                    
                    sheetContext.learningVocabularies = allVocabularies
                    
                }else if selectionContext.listSelections.isDuplicatesSelected {
                    
                    sheetContext.learningVocabularies = duplicatesRecognizer.valuesWithDuplicate(within: allVocabularies)
                    
                } else if selectionContext.listSelections.isAnyListSelected {
                    
                    guard let listIdentifiers = selectionContext.listSelections.listIdentifiers else { return }
                    guard let firstList = modelContext.fetchLists(.byIdentifiers(listIdentifiers)).first else { return }
                    sheetContext.learningVocabularies = firstList.vocabularies
                    
                }
            }
            .disabled(selectionContext.listSelections.isAnySelected == false)
        }
    }
}
