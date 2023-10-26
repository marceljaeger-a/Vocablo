//
//  PackNavigationView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 24.10.23.
//

import SwiftUI
import SwiftData

struct PackNavigationView: View {
    @State var selectedList: VocabularyList?
    
    var body: some View {
        NavigationSplitView {
            SidebarView(selectedList: $selectedList)
        } detail: {
            if let selectedList {
                ListTableView(list: selectedList)
            } else {
                ContentUnavailableView("No selected list!", systemImage: "book.pages", description: Text("Select a list on the sidebar."))
            }
        }
        .navigationTitle("")
    }
}

fileprivate struct SidebarView: View {
    @Environment(\.modelContext) var context: ModelContext
    @Query var lists: Array<VocabularyList>
    @Query var tags: Array<Tag>
    @Query var vocabularies: Array<Vocabulary>
    
    @Binding var selectedList: VocabularyList?
    
    var body: some View {
        List(selection: $selectedList){
            Section("Lists") {
                ForEach(lists, id: \.self) { list in
                    @Bindable var bindedList = list
                    Label {
                        TextField("", text: $bindedList.name)
                    } icon: {
                        Image(systemName: "book.pages")
                    }
                    .contextMenu {
                        Button {
                            deleteList(list)
                        } label: {
                            Text("Remove")
                        }
                    }
                    .dropDestination(for: Vocabulary.TransferType.self) {
                        dropVocabulariesOnList(on: list, items: $0, location: $1)
                    }
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
                    .dropDestination(for: Vocabulary.TransferType.self) {
                        dropVocabulariesOnTag(on: tag, items: $0, location: $1)
                    }
                }
                .selectionDisabled()
            }
        }
        .overlay {
            ZStack(alignment: .topLeading){
                Color.gray.opacity(0)
                
                VStack {
                    Spacer()
                        
                    HStack{
                        Button {
                            addList()
                        } label: {
                            Label("New List", systemImage: "plus.circle")
                        }
                        .buttonStyle(.borderless)
                        
                        Spacer()
                        
                        Button {
                            addTag()
                        } label: {
                            Image(.tagPlus)
                        }
                        .buttonStyle(.borderless)
                    }
                    .padding(8)
                    .background(.thickMaterial, in: .containerRelative)
                }
            }
        }
    }
    
    private func addList() {
        let newList = VocabularyList("New List")
        context.insert(newList)
    }
    
    private func deleteList(_ deletingList: VocabularyList) {
        context.delete(deletingList)
    }
    
    private func addTag() {
        let newTag = Tag("New Tag")
        context.insert(newTag)
    }
    
    private func deleteTag(_ deletingTag: Tag) {
        context.delete(deletingTag)
    }
    
    private func dropVocabulariesOnList(on list: VocabularyList, items: [Vocabulary.TransferType], location: CGPoint) -> Bool {
        for item in items {
            let vocabulary: Optional<Vocabulary> = item.pickObject(fetched: vocabularies)
            
            guard let vocabulary else { continue }
            if !list.containVocabulary(vocabulary) {
                vocabulary.list = list
            }
        }
        return true
    }
    
    private func dropVocabulariesOnTag(on tag: Tag, items: [Vocabulary.TransferType], location: CGPoint) -> Bool {
        for item in items {
            let vocabulary = item.pickObject(fetched: vocabularies)
            
            guard let vocabulary else { continue }
            vocabulary.safelyTag(tag)
        }
        
        return true
    }
}

#Preview {
    PackNavigationView()
        .previewModelContainer()
}