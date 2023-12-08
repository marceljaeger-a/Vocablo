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
    @Binding var selectedListIDs: Set<PersistentIdentifier>
    
    @Environment(\.modelContext) var context: ModelContext
    @Query(sort: \VocabularyList.created, order: .forward) var lists: Array<VocabularyList>
    
    @State var listDeleteConfirmationDialogState: (isShowing: Bool, deletingLists: Array<VocabularyList>) = (false, [])
    var bindedIsShowingListDeleteConfirmationDialog: Binding<Bool> {
        Binding {
            listDeleteConfirmationDialogState.isShowing
        } set: { newValue in
            listDeleteConfirmationDialogState.isShowing = newValue
        }

    }
    var listDeletingConfirmationDialogText: String {
        if selectedListIDs.count > 1 {
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
                context.addList("New List")
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
        .contextMenu(forSelectionType: PersistentIdentifier.self) { listIDs in
            if listIDs.isEmpty {
                Button {
                    context.addList("New List")
                } label: {
                    Text("New list")
                }
            }else {
                if listIDs.count == 1 {
                    if let firstList: VocabularyList = context.fetch(ids: listIDs).first {
                        @Bindable var bindedList = firstList
                        Picker("Sort by", selection: $bindedList.sorting) {
                            VocabularyList.VocabularySorting.pickerContent
                        }
                        
                        Divider()
                    }
                }
                
                Button {
                    context.resetList(context.fetch(ids: listIDs))
                } label: {
                    if listIDs.count > 1 {
                        Text("Reset selected")
                    }else {
                        Text("Reset")
                    }
                }
                
                Divider()
                
                Button {
                    pressDeleteButton(listIDs: listIDs)
                } label: {
                    if listIDs.count > 1 {
                        Text("Delete selected")
                    }else {
                        Text("Delete")
                    }
                }
            }
        }
        .deletingConfirmationDialog(isPresented: bindedIsShowingListDeleteConfirmationDialog, title: listDeletingConfirmationDialogText) {
            listDeleteConfirmationDialogState = (false, [])
        } deletingAction: {
            deleteLists(listDeleteConfirmationDialogState.deletingLists)
        }
    }
    
    private func listsContainVocabulary(_ lists: Array<VocabularyList>) -> Bool {
        for list in lists {
            if !list.vocabularies.isEmpty {
                return true
            }
        }
        return false
    }
    
    private func pressDeleteButton(listIDs: Set<PersistentIdentifier>) {
        let lists: Array<VocabularyList> = context.fetch(ids: listIDs)
        if listsContainVocabulary(lists) {
            listDeleteConfirmationDialogState = (true, lists)
        }else {
            deleteLists(lists)
        }
    }
    
    private func deleteLists(_ lists: Array<VocabularyList>) {
        let deletingLists = lists
        for deletingList in deletingLists {
            selectedListIDs.remove(deletingList.id)
        }
        context.deleteLists(deletingLists)
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
