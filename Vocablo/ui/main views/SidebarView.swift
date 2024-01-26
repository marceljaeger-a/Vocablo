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
    
    @Binding var learningList: VocabularyList?
    
    @Environment(\.actionReactingService) private var actionPublisherService
    @Environment(\.selections) private var selections
    @Environment(\.modelContext) private var context: ModelContext
    @Query(sort: \VocabularyList.created, order: .forward) private var allLists: Array<VocabularyList>
    @FocusState private var focusedList: PersistentIdentifier?
    @State private var listDeleteConfirmationDialogState: (isShowing: Bool, deletingLists: Array<VocabularyList>) = (false, [])
    let learningValueCounter: LearningValueManager = LearningValueManager()
    private var bindedIsShowingListDeleteConfirmationDialog: Binding<Bool> {
        Binding {
            listDeleteConfirmationDialogState.isShowing
        } set: { newValue in
            listDeleteConfirmationDialogState.isShowing = newValue
        }

    }
    private var listDeletingConfirmationDialogText: String {
        if selections.selectedListIdentifiers.count > 1 {
            "Do you want to delete the selected lists?"
        }else {
            "Do you want to delete the list?"
        }
    }
    
    //MARK: - Methodes
    
    private func focusNewList(_ list: VocabularyList) {
        focusedList = list.id
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
        
        let fetchedSelectedLists: Array<VocabularyList> = context.fetch(by: listIdentifiers)
        
        if withConfirmationDialog {
            if areListsEmtpy(fetchedSelectedLists) == false {
                listDeleteConfirmationDialogState = (true, fetchedSelectedLists)
                return
            }
        }
    
        _ = selections.unselectLists(listIdentifiers)
        context.delete(models: fetchedSelectedLists)
    }
    
    private func showLearningSheet(listIdentifiers: Set<PersistentIdentifier>) {
        guard let firstFetchedList: VocabularyList = context.fetch(by: listIdentifiers).first else { return }
        self.learningList = firstFetchedList
    }
    
    private func addNewList() {
        let newList = context.addList("New List")
        actionPublisherService.send(action: \.addingList, input: newList)
    }
    
    //MARK: - Body
    
    var body: some View {
        List(selection: selections.bindable.selectedListIdentifiers) {
            NavigationLink {
                VocabularyListDetailView(of: nil, learningList: $learningList)
            } label: {
                Label("All vocabularies", systemImage: "tray.full")
                    .badge((try? context.fetchCount(FetchDescriptor<Vocabulary>())) ?? 0, prominece: .decreased)
            }

            listSection
        }
        .buttomButtons(onLeft: {
            Button {
                addNewList()
            } label: {
                Label("New List", systemImage: "plus.circle")
            }
            .buttonStyle(.borderless)
        })
        .contextMenu(forSelectionType: PersistentIdentifier.self) { listIdentifiers in
            contextMenuButtons(listIdfentifiers: listIdentifiers)
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
    var listSection: some View {
        Section("Lists") {
            ForEach(allLists, id: \.id) { list in
                @Bindable var bindedList = list
                Label {
                    TextField("", text: $bindedList.name)
                        .focused($focusedList, equals: list.id)
                } icon: {
                    Image(systemName: "book.pages")
                }
                .badge(learningValueCounter.algorithmedLearningValuesCount(of: list), prominece: .increased)
                .badge("\(list.vocabularies.count)", prominece: .decreased)
            }
            .onDelete { indexSet in //Only when selected lists are focused! This condition is implicit by SwiftUI.
                self.deleteSelectedLists(listIdentifiers: allLists[indexSet].identifiers, withConfirmationDialog: true)
            }
        }
    }
    
    @ViewBuilder func contextMenuButtons(listIdfentifiers: Set<PersistentIdentifier>) -> some View {
        Button {
            addNewList()
        } label: {
            Text("New list")
        }
        .disabled(listIdfentifiers.isEmpty == false)
        
        Divider()

        Button {
            self.showLearningSheet(listIdentifiers: listIdfentifiers)
        } label: {
            Text("Start learning")
        }
        .disabled(listIdfentifiers.count != 1)
        
        Divider()
        
        if let firstFetchedList: VocabularyList = context.fetch(by: listIdfentifiers).first {
            @Bindable var bindedFirstFetchedList = firstFetchedList
            Picker("Sort by", selection: $bindedFirstFetchedList.sorting) {
                VocabularyList.VocabularySorting.pickerContent
            }
            .disabled(listIdfentifiers.count != 1)
        }else {
            Text("Sort by")
                .disabled(listIdfentifiers.count != 1)
        }
        
        Divider()
        
        Button {
            let fetchedSelectedLists: Array<VocabularyList> = context.fetch(by: listIdfentifiers)
            context.resetLearningStates(of: fetchedSelectedLists)
        } label: {
            if listIdfentifiers.count > 1 {
                Text("Reset selected")
            }else {
                Text("Reset")
            }
        }
        .disabled(listIdfentifiers.isEmpty == true)
        
        Button {
            self.deleteSelectedLists(listIdentifiers: listIdfentifiers, withConfirmationDialog: true)
        } label: {
            if listIdfentifiers.count > 1 {
                Text("Delete selected")
            }else {
                Text("Delete")
            }
        }
        .disabled(listIdfentifiers.isEmpty == true)
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


