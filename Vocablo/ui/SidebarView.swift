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
    
    @Binding var selectedListIdentifiers: Set<PersistentIdentifier>
    
    @Environment(\.modelContext) private var context: ModelContext
    @Query(sort: \VocabularyList.created, order: .forward) private var allLists: Array<VocabularyList>
    @FocusState private var focusedList: PersistentIdentifier?
    @State private var listDeleteConfirmationDialogState: (isShowing: Bool, deletingLists: Array<VocabularyList>) = (false, [])
    private var bindedIsShowingListDeleteConfirmationDialog: Binding<Bool> {
        Binding {
            listDeleteConfirmationDialogState.isShowing
        } set: { newValue in
            listDeleteConfirmationDialogState.isShowing = newValue
        }

    }
    private var listDeletingConfirmationDialogText: String {
        if selectedListIdentifiers.count > 1 {
            "Do you want to delete the selected lists?"
        }else {
            "Do you want to delete the list?"
        }
    }
    
    //MARK: - Methodes
    
    private func focusAndSelectNewList(_ list: VocabularyList) {
        focusedList = nil //This helps for the "AttributeGraph" message!
        selectedListIdentifiers = []
        selectedListIdentifiers.insert(list.id) //This causes an "AttributeGraph" message!
        Task {  //This helps for the nonfocsuing, when an other list is focued, while I add a new list.
            focusedList = list.id
        }
    }
    
    private func areListsEmtpy(_ lists: Array<VocabularyList>) -> Bool {
        for list in lists {
            if !list.vocabularies.isEmpty {
                return false
            }
        }
        return true
    }
    
    private func deleteSelectedLists(_ lists: Array<VocabularyList>) {
        let deletingLists = lists
        for deletingList in deletingLists {
            selectedListIdentifiers.remove(deletingList.id)
        }
        context.deleteLists(deletingLists)
    }
    
    //MARK: - Body
    
    var body: some View {
        List(selection: $selectedListIdentifiers){
            listSection
        }
        .buttomButtons(onLeft: {
            Button {
                context.addList("New List")
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
        }
        .onAddList { newList in
            focusAndSelectNewList(newList)
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
                .badge(list.learningVocabulariesTodayCount, prominece: .increased)
                .badge("\(list.vocabularies.count)", prominece: .decreased)
            }
        }
    }
    
    @ViewBuilder func contextMenuButtons(listIdfentifiers: Set<PersistentIdentifier>) -> some View {
        if listIdfentifiers.isEmpty {
            Button {
                context.addList("New List")
            } label: {
                Text("New list")
            }
        }else {
            if listIdfentifiers.count == 1 {
                if let firstList: VocabularyList = context.fetch(by: listIdfentifiers).first {
                    @Bindable var bindedList = firstList
                    Picker("Sort by", selection: $bindedList.sorting) {
                        VocabularyList.VocabularySorting.pickerContent
                    }
                    
                    Divider()
                }
            }
            
            Button {
                let selectedLists: Array<VocabularyList> = context.fetch(by: listIdfentifiers)
                context.resetLearningStates(of: selectedLists)
            } label: {
                if listIdfentifiers.count > 1 {
                    Text("Reset selected")
                }else {
                    Text("Reset")
                }
            }
            
            Divider()
            
            Button {
                let fetchedLists: Array<VocabularyList> = context.fetch(by: listIdfentifiers)
                
                if areListsEmtpy(fetchedLists) {
                    listDeleteConfirmationDialogState = (true, fetchedLists)
                }else {
                    deleteSelectedLists(fetchedLists)
                }
            } label: {
                if listIdfentifiers.count > 1 {
                    Text("Delete selected")
                }else {
                    Text("Delete")
                }
            }
        }
    }
    
    @ViewBuilder var listDeletingConfirmationDialgoButtons: some View {
        Button(role: .cancel){
            listDeleteConfirmationDialogState = (false, [])
        } label: {
            Text("Cancel")
        }
        
        Button(role: .destructive){
            deleteSelectedLists(listDeleteConfirmationDialogState.deletingLists)
        } label: {
            Text("Delete")
        }
    }
}


