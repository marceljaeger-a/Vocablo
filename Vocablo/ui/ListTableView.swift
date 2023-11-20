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
    
    @FocusState var focusedVocabulary: VocabularyTextFieldFocusState?
    enum VocabularyTextFieldFocusState: Hashable{
        case word(PersistentIdentifier), translatedWord(PersistentIdentifier), explenation(PersistentIdentifier), sentence(PersistentIdentifier), translatedSentence(PersistentIdentifier)
    }
    
    @State var selectedVocabularyIdentifiers: Set<PersistentIdentifier> = Set()
    var selectedVocabularies: Array<Vocabulary> {
        let vocabularies = list.vocabularies
        return vocabularies.filter { element in
            selectedVocabularyIdentifiers.contains(element.id)
        }
    }
    
    var body: some View {
        Table(of: Vocabulary.self, selection: $selectedVocabularyIdentifiers) {
            TableColumn("Learnable") { vocabulary in
                VocabularyToggle(vocabulary: vocabulary, property: \.isLearnable)
            }
            .width(60)
            
            TableColumn("Englisch word") { vocabulary in
                VocabularyTextField(vocabulary: vocabulary, value: \.word, placeholder: "Word in english...")
                    .bold()
                    .onSubmit {
                        addVocabulary()
                    }
                    .focused($focusedVocabulary, equals: VocabularyTextFieldFocusState.word(vocabulary.id))
            }
            .width(200)
            
            TableColumn("German word") { vocabulary in
                VocabularyTextField(vocabulary: vocabulary, value: \.translatedWord, placeholder: "Word in german...")
                    .onSubmit {
                        addVocabulary()
                    }
                    .focused($focusedVocabulary, equals: VocabularyTextFieldFocusState.translatedWord(vocabulary.id))
            }
            .width(200)
            
            TableColumn("Explanation") { vocabulary in
                VocabularyTextField(vocabulary: vocabulary, value: \.explenation, placeholder: "Explenation in english...")
                    .onSubmit {
                        addVocabulary()
                    }
                    .focused($focusedVocabulary, equals: VocabularyTextFieldFocusState.explenation(vocabulary.id))
            }
            .width(250)
            
            TableColumn("English Sentence") { vocabulary in
                VocabularyTextField(vocabulary: vocabulary, value: \.sentence, placeholder: "Sentence in english...")
                    .onSubmit {
                        addVocabulary()
                    }
                    .focused($focusedVocabulary, equals: VocabularyTextFieldFocusState.sentence(vocabulary.id))
            }
            
            TableColumn("German Sentence") { vocabulary in
                VocabularyTextField(vocabulary: vocabulary, value: \.translatedSentence, placeholder: "Sentence in english...")
                    .onSubmit {
                        addVocabulary()
                    }
                    .focused($focusedVocabulary, equals: VocabularyTextFieldFocusState.translatedSentence(vocabulary.id))
            }
            
            TableColumn("Word group") { vocabulary in
                WordGroupPicker(vocabulary: vocabulary)
            }
            .width(100)
            
            TableColumn("") { vocabulary in
                VocabularyInfoButton(vocabulary: vocabulary)
            }
            .width(20)
        } rows: {
            ForEach(list.vocabularies.sorted(using: KeyPathComparator(\.created))) { vocabulary in
                TableRow(vocabulary)
                    .contextMenu {
                        Button {
                            //                            #error("When I delete a vocabulary, that´s text field is focused, the preview crashes!")
                            if !selectedVocabularies.isEmpty {
                                for selectedVocabulary in selectedVocabularies {
                                    guard selectedVocabulary != vocabulary else { continue }
                                    deleteVocabulary(selectedVocabulary)
                                }
                            }
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
        focusedVocabulary = .word(newVocabulary.id)
        selectedVocabularyIdentifiers = [newVocabulary.id]
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
    let arrow: ArrowSymbole
    
    enum ArrowSymbole: String {
        case arrowRight = "arrow.right"
        case arrowLeft = "arrow.left"
    }
    
    var body: some View {
        Label {
            Text("\(vocabulary[keyPath: learningState].currentLevel.rawValue) / \(vocabulary[keyPath: learningState].remainingTimeLabel)")
        } icon: {
            HStack(spacing: 0) {
                Image(systemName: "a.square")
                Image(systemName: arrow.rawValue)
                Image(systemName: "b.square")
            }
        }
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

fileprivate struct VocabularyInfoButton: View {
    @Query var tags: Array<Tag>
    
    let vocabulary: Vocabulary
    
    @State var showPopover: Bool = false
    
    var body: some View {
        Button {
            showPopover = true
        } label: {
            Image(systemName: "info.circle")
        }
        .popover(isPresented: $showPopover, arrowEdge: .trailing) {
            infoPopover
        }
    }
    
    var infoPopover: some View {
        VStack(alignment: .leading) {
            VStack {
                LearningStateLabel(vocabulary: vocabulary, learningState: \.learningState, arrow: .arrowRight)
                LearningStateLabel(vocabulary: vocabulary, learningState: \.translatedLearningState, arrow: .arrowLeft)
            }
            .padding([.top, .horizontal] , 15)
            .padding(.bottom, 5)
            
            Divider()
            
            HStack {
                Image(systemName: "tag")
                TagMultiPicker(vocabulary: vocabulary, tags: tags)
            }
            .padding([.bottom, .horizontal] , 15)
            .padding(.top, 5)
        }
        .foregroundStyle(.secondary)
    }
}

#Preview {
    ListTableView(list: VocabularyList("Preview List"))
        .previewModelContainer()
}
