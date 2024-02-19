//
//  SidebarView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 29.11.23.
//

import Foundation
import SwiftUI
import SwiftData

struct SidebarView: View {
    
    //MARK: - Properties
    
    @AppStorage("isDuplicatesNavigationLinkAlwaysShown") var isDuplciatesNavigationLinkAlwaysShown: Bool = false
    
    @Environment(\.actionReactingService) private var actionPublisherService
    @Environment(\.selectionContext) private var selectionContext
    @Environment(\.sheetContext) private var sheetContext
    @Environment(\.modelContext) private var modelContext: ModelContext
    @Query(sort: \VocabularyList.created, order: .forward) private var allLists: Array<VocabularyList>
    @Query private var allVocabularies: Array<Vocabulary>
    @FocusState private var focusedList: PersistentIdentifier?
    @State private var listDeleteConfirmationDialogState: (isShowing: Bool, deletingLists: Array<VocabularyList>) = (false, [])
    let duplicatesRecognizer = DuplicateRecognitionService()
    let learningValueCounter: LearningValueManager = LearningValueManager()
    private var bindedIsShowingListDeleteConfirmationDialog: Binding<Bool> {
        Binding {
            listDeleteConfirmationDialogState.isShowing
        } set: { newValue in
            listDeleteConfirmationDialogState.isShowing = newValue
        }

    }
    private var listDeletingConfirmationDialogText: String {
        if selectionContext.listSelections.listCount > 1 {
            "Do you want to delete the selected lists?"
        }else {
            "Do you want to delete the list?"
        }
    }
    
    //MARK: - Methodes
    
    private func focusNewList(_ list: VocabularyList) {
        focusedList = list.id
    }
    
    private func addNewList() {
        let newList: VocabularyList = .newList
        modelContext.insert(newList)
        do {
            try modelContext.save()
        }catch {
            print("Saving adding new list failed!")
        }
        actionPublisherService.send(action: \.addingList, input: newList)
    }
    
    private func showLearningSheet(listSelections: ListSelectionSet) {
        var learningVocabularies: Array<Vocabulary> = []
        
        if listSelections.isAllVocabulariesSelected {
            learningVocabularies.append(contentsOf: allVocabularies)
            
        }else if listSelections.isDuplicatesSelected {
            
            let duplicateVocabularies = duplicatesRecognizer.valuesWithDuplicate(within: allVocabularies)
            learningVocabularies.append(contentsOf: duplicateVocabularies)
            
        }else if listSelections.isAnyListSelected {
            
            guard let listIdentifiers = listSelections.listIdentifiers else { return }
            
            let fetchedLists = modelContext.fetchLists(.byIdentifiers(listIdentifiers))
            
            for fetchedList in fetchedLists {
                learningVocabularies.append(contentsOf: fetchedList.vocabularies)
            }
            
        }
        
        sheetContext.learningVocabularies = learningVocabularies    }
    
    private func resetLists(listSelections: ListSelectionSet) {
        if listSelections.isAllVocabulariesSelected {
        
            allVocabularies.forEach { $0.resetLearningsStates() }
            
        }else if listSelections.isDuplicatesSelected {
            
            let duplicateVocabularies = duplicatesRecognizer.valuesWithDuplicate(within: allVocabularies)
            duplicateVocabularies.forEach { $0.resetLearningsStates() }
            
        }else if listSelections.isAnyListSelected {
            
            guard let listIdentifiers = listSelections.listIdentifiers else { return }
            let lists = modelContext.fetchLists(.byIdentifiers(listIdentifiers))
            lists.forEach { $0.resetLearningStates() }
            
        }
    }
    
    private func deleteSelectedLists(listIdentifiers: Set<PersistentIdentifier>, withConfirmationDialog: Bool) {
        func areListsEmtpy(_ lists: Array<VocabularyList>) -> Bool {
            for list in lists {
                if !list.vocabularies.isEmpty {
                    return false
                }
            }
            return true
        }
        
        let fetchedSelectedLists = modelContext.fetchLists(.byIdentifiers(listIdentifiers))
        
        if withConfirmationDialog {
            if areListsEmtpy(fetchedSelectedLists) == false {
                listDeleteConfirmationDialogState = (true, fetchedSelectedLists)
                return
            }
        }
    
        _ = selectionContext.listSelections.unselectLists(listIdentifiers)
        modelContext.delete(models: fetchedSelectedLists)
    }
    
    //MARK: - Body
    
    var body: some View {
        List(selection: selectionContext.bindable.listSelections.selections) {
            appListsSection
            
            listsSection
        }
        .buttomButtons(onLeft: {
            Button {
                addNewList()
            } label: {
                Label("New List", systemImage: "plus.circle")
            }
            .buttonStyle(.borderless)
        })
        .contextMenu(forSelectionType: ListSelectionValue.self) { listSelectionValues in
            contextMenu(listSelections: .init(values: listSelectionValues))
        }
        .confirmationDialog(listDeletingConfirmationDialogText, isPresented: bindedIsShowingListDeleteConfirmationDialog) {
            listDeletingConfirmationDialgoButtons
        } message: {
            Text("Contained vocabularies will be deleted!")
        }
        .onAction(\.addingList) { newList in
            focusNewList(newList)
        }
    }
}



//MARK: - Subviews

extension SidebarView {
    var appListsSection: some View {
        Group {
            Label("All vocabularies", systemImage: "tray.full")
                .badge(learningValueCounter.algorithmedLearningValuesCount(of: allVocabularies), prominece: .increased)
                .badge((try? modelContext.fetchCount(FetchDescriptor<Vocabulary>())) ?? 0, prominece: .decreased)
                .tag(ListSelectionValue.allVocabularies)
            
            if duplicatesRecognizer.valuesWithDuplicate(within: allVocabularies).isEmpty == false || isDuplciatesNavigationLinkAlwaysShown == true {
                Label("Duplicates", image: .duplicateWarning)
                    .badge(learningValueCounter.algorithmedLearningValuesCount(of: duplicatesRecognizer.valuesWithDuplicate(within: allVocabularies)), prominece: .increased)
                    .badge(duplicatesRecognizer.valuesWithDuplicate(within: allVocabularies).count, prominece: .decreased)
                    .tag(ListSelectionValue.duplicates)
            }
        }
    }
    
    var listsSection: some View {
        Section("Lists") {
            ForEach(allLists, id: \.id) { list in
                @Bindable var bindedList = list
                Label {
                    TextField("", text: $bindedList.name)
                        .focused($focusedList, equals: list.id)
                } icon: {
                    Image(systemName: "book.pages")
                }
                .badge(learningValueCounter.algorithmedLearningValuesCount(of: list.vocabularies), prominece: .increased)
                .badge("\(list.vocabularies.count)", prominece: .decreased)
                .tag(ListSelectionValue.list(identifier: list.id))
            }
            .onDelete { indexSet in //Only when selected lists are focused! This condition is implicit by SwiftUI.
                self.deleteSelectedLists(listIdentifiers: allLists[indexSet].identifiers, withConfirmationDialog: true)
            }
        }
    }
    
    @ViewBuilder func contextMenu(listSelections: ListSelectionSet) -> some View {
        Button("New list") {
            addNewList()
        }
        .disabled(listSelections.isAnySelected)
        
        Divider()
        
        Button {
            showLearningSheet(listSelections: listSelections)
        }label: {
            if listSelections.listCount > 1 {
                Text("Learn lists")
            }else {
                Text("Learn list")
            }
        }
        .disabled(listSelections.isAnySelected == false)
        
        Divider()
        
        if let firstFetchedList: VocabularyList = modelContext.fetchLists(.byIdentifiers(listSelections.listIdentifiers ?? []) ).first, listSelections.listCount == 1 {
            @Bindable var bindedFirstFetchedList = firstFetchedList
            Picker("Sort list by", selection: $bindedFirstFetchedList.sorting) {
                VocabularyList.VocabularySorting.pickerContent
            }
        }else {
            Text("Sort list by")
        }
        
        Divider()
        
        Button {
            resetLists(listSelections: listSelections)
        }label: {
            if listSelections.listCount > 1 {
                Text("Reset lists")
            }else {
                Text("Reset list")
            }
        }
        .disabled(listSelections.isAnySelected == false)
        
        Button {
            guard let listIdentifiers = listSelections.listIdentifiers else { return }
            deleteSelectedLists(listIdentifiers: listIdentifiers, withConfirmationDialog: true)
        } label: {
            if listSelections.listCount > 1 {
                Text("Delete lists")
            }else {
                Text("Delete list")
            }
        }
        .disabled(listSelections.isAnyListSelected == false)
    }

    @ViewBuilder var listDeletingConfirmationDialgoButtons: some View {
        Button(role: .cancel){
            self.listDeleteConfirmationDialogState = (false, [])
        } label: {
            Text("Cancel")
        }
        
        Button(role: .destructive){
            self.deleteSelectedLists(listIdentifiers: listDeleteConfirmationDialogState.deletingLists.identifiers, withConfirmationDialog: false)
        } label: {
            Text("Delete")
        }
    }
}


