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
                    .contextMenu {
                        Picker("Sort by", selection: $bindedList.sorting) {
                            VocabularyList.VocabularySorting.pickerContent
                        }
                        
                        Divider()
                        
                        Button {
                            deleteSelectedLists(and: list)
                        } label: {
                            Text("Remove")
                        }
                    }
                    //TODO: Remove this!
                }
            }
            Section("Tags") {
                ForEach(tags) { tag in
                    @Bindable var bindedTag = tag
                    
                    Label {
                        TextField("", text: $bindedTag.name)
                    } icon: {
                        Image(systemName: "tag")
                    }
                    .contextMenu {
                        Button {
                            deleteTag(tag)
                        } label: {
                            Text("Remove")
                        }
                    }
                }
                .selectionDisabled()
            }
        }
        .buttomToolbar(leftButton: {
            Button {
                addList()
            } label: {
                Label("New List", systemImage: "plus.circle")
            }
            .buttonStyle(.borderless)
        }, rightButton: {
            Button {
                addTag()
            } label: {
                Image(.tagPlus)
            }
            .buttonStyle(.borderless)
        })
    }
    
    private func addList() {
        let newList = VocabularyList("New List")
        context.insert(newList)
    }
    
//    private func deleteList(_ deletingList: VocabularyList) {
//        context.delete(deletingList)
//    }
    
    private func deleteSelectedLists(and list: VocabularyList) {
        for selectedList in selectedLists {
            guard selectedList != list else { continue }
            selectedListIDs.remove(selectedList.id)
            context.delete(selectedList)
        }
        
        selectedListIDs.remove(list.id)
        context.delete(list)
    }
    
    private func addTag() {
        let newTag = Tag("New Tag")
        context.insert(newTag)
    }
    
    private func deleteTag(_ deletingTag: Tag) {
        context.delete(deletingTag)
    }
}
