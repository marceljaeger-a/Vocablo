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
    @Environment(\.modelContext) var context: ModelContext
    @Query(sort: \VocabularyList.created, order: .forward) var lists: Array<VocabularyList>
    @Query(sort: \Tag.name, order: .forward) var tags: Array<Tag>
    @Query var vocabularies: Array<Vocabulary>
    
    @Binding var selectedListIDs: Set<PersistentIdentifier>
    var selectedLists: Array<VocabularyList> {
        lists.filter { list in
            selectedListIDs.contains(list.id)
        }
    }
    
    @State var showListDeleteConfirmationDialog: Bool = false
    var listDeletingConfirmationDialogText: String {
        if selectedLists.count > 1 {
            "Do you want to delete the selected lists?"
        }else {
            "Do you want to delete the list?"
        }
    }
    
    var body: some View {
//        ("This was the problem of #16, because I do not use the id as selection. Maybe because of the List and the wrapped ForEach, but I do not now. But I know, that this was the problem of the duplicate key error!")
        List(selection: $selectedListIDs){
            Section("Lists") {
                ForEach(lists, id: \.id) { list in
                    @Bindable var bindedList = list
                    Label {
                        TextField("", text: $bindedList.name)
                    } icon: {
                        Image(systemName: "book.pages")
                    }
                    .badge(list.learningVocabulariesTodayCount, prominece: .increased)
                    .badge("\(list.vocabularies.count)", prominece: .decreased)
                }
            }
//            Section("Tags") {
//                ForEach(tags) { tag in
//                    @Bindable var bindedTag = tag
//                    
//                    Label {
//                        TextField("", text: $bindedTag.name)
//                    } icon: {
//                        Image(systemName: "tag")
//                    }
//                    .contextMenu {
//                        Button {
//                            deleteTag(tag)
//                        } label: {
//                            Text("Remove")
//                        }
//                    }
//                }
//                .selectionDisabled()
//            }
        }
        .buttomToolbar(leftButton: {
            Button {
                addList()
            } label: {
                Label("New List", systemImage: "plus.circle")
            }
            .buttonStyle(.borderless)
        }, rightButton: {
            Text("")
//            Button {
//                addTag()
//            } label: {
//                Image(.tagPlus)
//            }
//            .buttonStyle(.borderless)
        })
        .contextMenu(forSelectionType: PersistentIdentifier.self) { vocabularyIDs in
            if vocabularyIDs.isEmpty {
                Button {
                    addList()
                } label: {
                    Text("New list")
                }
            }else {
                if vocabularyIDs.count == 1 {
                    if let firstList = selectedLists.first {
                        @Bindable var bindedList = firstList
                        Picker("Sort by", selection: $bindedList.sorting) {
                            VocabularyList.VocabularySorting.pickerContent
                        }
                        
                        Divider()
                    }
                }
                Button {
                    showListDeleteConfirmationDialog = true
                } label: {
                    if vocabularyIDs.count > 1 {
                        Text("Delete selected")
                    }else {
                        Text("Delete")
                    }
                }
            }
        }
        .deletingConfirmationDialog(isPresented: $showListDeleteConfirmationDialog, title: listDeletingConfirmationDialogText) {
            showListDeleteConfirmationDialog = false
        } deletingAction: {
            deleteLists()
        }
    }
    
    private func addList() {
        let newList = VocabularyList("New List")
        context.insert(newList)
    }
    
    private func deleteLists() {
        let deletingLists = selectedLists
        for deletingList in deletingLists {
            selectedListIDs.remove(deletingList.id)
        }
        context.deleteVocabularyLists(deletingLists)
    }
    
//    private func addTag() {
//        let newTag = Tag("New Tag")
//        context.insert(newTag)
//    }
//    
//    private func deleteTag(_ deletingTag: Tag) {
//        context.delete(deletingTag)
//    }
}
