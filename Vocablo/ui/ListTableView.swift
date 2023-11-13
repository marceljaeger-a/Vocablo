//
//  ListDetailView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 24.10.23.
//

import SwiftUI
import SwiftData

struct ListTableView: View {
    @Environment(\.modelContext) var context: ModelContext
    @Query var tags: Array<Tag>
    
    @Bindable var list: VocabularyList
    
    @State var showLearningSheet: Bool = false
    
    @FocusState var focusedVocabulary: PersistentIdentifier?
    
    var body: some View {
        Table(of: Vocabulary.self) {
            TableColumn("Englisch word") { vocabulary in
                @Bindable var bindedVocabulary = vocabulary
                VocabularyTextField(vocabulary: vocabulary, value: \.word, placeholder: "Word in english...")
                    .bold()
                    .onSubmit {
                        addVocabulary()
                    }
                    .focused($focusedVocabulary, equals: vocabulary.id)
            }
            
            TableColumn("German word") { vocabulary in
                VocabularyTextField(vocabulary: vocabulary, value: \.translatedWord, placeholder: "Word in german...")
                    .onSubmit {
                        addVocabulary()
                    }
            }
            
            TableColumn("Explanation") { vocabulary in
                VocabularyTextField(vocabulary: vocabulary, value: \.explenation, placeholder: "Explenation in english...")
                    .onSubmit {
                        addVocabulary()
                    }
            }
            
            TableColumn("Word group") { vocabulary in
                WordGroupPicker(vocabulary: vocabulary)
            }
            .width(100)
            
            TableColumn("Learnable") { vocabulary in
                VocabularyToggle(vocabulary: vocabulary, property: \.isLearnable)
            }
            .width(65)
            
            TableColumn("State (Level / next Repetition)") { vocabulary in
                LearningStateLabel(vocabulary: vocabulary, learningState: \.learningState)
            }
            
            TableColumn("State of translation (Level / next Repetition)") { vocabulary in
                LearningStateLabel(vocabulary: vocabulary, learningState: \.translatedLearningState)
            }
            
            TableColumn("Tags") { vocabulary in
                TagMultiPicker(vocabulary: vocabulary, tags: tags)
            }
        } rows: {
            ForEach(list.vocabularies.sorted(using: KeyPathComparator(\.created))) { vocabulary in
                TableRow(vocabulary)
                    .contextMenu {
                        Button {
                            //                            #error("When I delete a vocabulary, that´s text field is focused, the preview crashes!")
                            deleteVocabulary(vocabulary)
                        } label: {
                            Text("Remove")
                        }
                    }
                //.draggable(vocabulary.transferType)
            }
        }
        .tableStyle(.inset)
        .textFieldStyle(.plain)
        .autocorrectionDisabled(true)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    addVocabulary()
                } label: {
                    Image(.wordPlus)
                }
            }
            ToolbarItem(placement: .secondaryAction) {
                Button {
                    self.showLearningSheet = true
                } label: {
                    Image(.wordlistPlay)
                }
            }
        }
        .sheet(isPresented: $showLearningSheet, content: {
            LearningView(list: list)
        })
    }
    
    private func deleteVocabulary(_ vocabulary: Vocabulary) {
        list.removeVocabulary(vocabulary)
        context.delete(vocabulary)
    }
    
    private func addVocabulary() {
        let newVocabulary = Vocabulary(word: "", translatedWord: "", wordGroup: .noun)
        list.addVocabulary(newVocabulary)
        focusedVocabulary = newVocabulary.id
    }

}

fileprivate struct VocabularyTextField: View {
    @Bindable var vocabulary: Vocabulary
    let value: KeyPath<Bindable<Vocabulary>, Binding<String>>
    let placeholder: String
    
    var body: some View {
        TextField("", text: $vocabulary[keyPath: value], prompt: Text(placeholder))
            .bold()
    }
}

fileprivate struct LearningStateLabel: View {
    let vocabulary: Vocabulary
    let learningState: KeyPath<Vocabulary, LearningState>
    
    var body: some View {
        Text("\(vocabulary[keyPath: learningState].currentLevel.rawValue) / \(vocabulary[keyPath: learningState].remainingTimeLabel)")
    }
}

fileprivate struct VocabularyToggle: View {
    @Bindable var vocabulary: Vocabulary
    var property: KeyPath<Bindable<Vocabulary>, Binding<Bool>>
    var body: some View {
        Toggle(isOn: $vocabulary[keyPath: property]) {
            
        }
    }
}

fileprivate struct WordGroupPicker: View {
    @Bindable var vocabulary: Vocabulary
    
    var body: some View {
        Menu(vocabulary.wordGroup.rawValue) {
            ForEach(WordGroup.allCases, id: \.rawValue) { wordGroup in
                Button {
                    vocabulary.wordGroup = wordGroup
                } label: {
                    Text(wordGroup.rawValue)
                }
                .disabled(vocabulary.wordGroup == wordGroup)
            }
        }
        .menuStyle(BorderlessButtonMenuStyle())
    }
}

fileprivate struct TagMultiPicker: View {
    @Bindable var vocabulary: Vocabulary
    let tags: Array<Tag>
    
    var body: some View {
        Menu {
            ForEach(tags) { tag in
                Button {
                    vocabulary.toggleTag(tag)
                } label: {
                    HStack {
                        Image(systemName: "tag")
                            .symbolVariant(vocabulary.hasTag(tag) ? .fill : .none)
                        
                        Text(tag.name)
                    }
                }
            }
        } label: {
            let tagListString = { () -> String in
                var tagsString = ""
                for tag in vocabulary.tags {
                    if tagsString.isEmpty {
                        tagsString += tag.name
                    }else {
                        tagsString += ", \(tag.name)"
                    }
                }
                return tagsString
            }()
            
            Text(tagListString)
        }
        .menuStyle(.borderlessButton)
    }
}

#Preview {
    ListTableView(list: VocabularyList("Preview List"))
        .previewModelContainer()
}
