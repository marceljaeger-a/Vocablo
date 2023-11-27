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
    
    var list: VocabularyList
    
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
    func getVocabularies(ids: Set<PersistentIdentifier>) -> Array<Vocabulary> {
        let vocabularies = list.vocabularies
        return vocabularies.filter { element in
            ids.contains(element.id)
        }
    }
    
    @State var sortState: VocabularySorting = .newest
    enum VocabularySorting: String {
        case newest = "Newest", oldest = "Oldest", word = "Word", translatedWord = "Translated Word"
        
        var sortComparator: KeyPathComparator<Vocabulary> {
            switch self {
            case .newest:
                KeyPathComparator(\Vocabulary.created, order: .reverse)
            case .oldest:
                KeyPathComparator(\Vocabulary.created, order: .forward)
            case .word:
                KeyPathComparator(\Vocabulary.word)
            case .translatedWord:
                KeyPathComparator(\Vocabulary.translatedWord)
            }
        }
        
        @ViewBuilder static var pickerContent: some View {
            Text("Oldest").tag(VocabularySorting.oldest)
            Text("Newest").tag(VocabularySorting.newest)
            Text("Word").tag(VocabularySorting.word)
            Text("Translated Word").tag(VocabularySorting.translatedWord)
        }
    }
    
    @State var editingVocabulary: Vocabulary?
    
    var body: some View {
        Table(list.vocabularies.sorted(using: sortState.sortComparator), selection: $selectedVocabularyIdentifiers) {
            TableColumn("Learnable") { vocabulary in
                VocabularyToggle(vocabulary: vocabulary, value: \.isLearnable)
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
        }
        .tableStyle(.inset)
        .contextMenu(forSelectionType: Vocabulary.ID.self, menu: { vocabularyIDs in
            if vocabularyIDs.isEmpty {
                Button {
                    addVocabulary()
                } label: {
                    Text("New vocabulary")
                }
            }else {
                if vocabularyIDs.count == 1 {
                    Button {
                        guard let firstVocabulary = getVocabularies(ids: vocabularyIDs).first else { return }
                        openEditVocabularyView(for: firstVocabulary)
                    } label: {
                        Text("Edit")
                    }
                    
                    Divider()
                }
                
                Button {
                    checkLearnable(of: getVocabularies(ids: vocabularyIDs))
                } label: {
                    Text("To learn")
                }
                
                Button {
                    uncheckLearnable(of: getVocabularies(ids: vocabularyIDs))
                } label: {
                    Text("Not to learn")
                }
                
                Divider()
                
                Button {
                    deleteVocabularies(getVocabularies(ids: vocabularyIDs))
                } label: {
                    if vocabularyIDs.count == 1 {
                        Text("Delete")
                    }else {
                        Text("Delete selected")
                    }
                }
            }
        }, primaryAction: { vocabularyIDs in
            if vocabularyIDs.count == 1 {
                guard let firstVocabulary = getVocabularies(ids: vocabularyIDs).first else { return }
                openEditVocabularyView(for: firstVocabulary)
            }
        })
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
            ToolbarItem(placement: .primaryAction) {
                Button {
                    self.showLearningSheet = true
                } label: {
                    Image(.wordlistPlay)
                }
            }
            ToolbarItem(placement: .status) {
                Picker(selection: $sortState) {
                    VocabularySorting.pickerContent
                } label: {
                    Text("\(sortState.rawValue)")
                }
            }
        }
        .sheet(isPresented: $showLearningSheet, content: {
            LearningView(list: list)
        })
        .sheet(item: $editingVocabulary) { vocabulary in
            EditVocabularyView(vocabulary: vocabulary)
        }
    }
    
    func openEditVocabularyView(for vocabulary: Vocabulary) {
        editingVocabulary = vocabulary
    }

    private func deleteVocabularies(_ vocabularies: Array<Vocabulary>) {
        for vocabulary in vocabularies {
            list.removeVocabulary(vocabulary)
            context.delete(vocabulary)
        }
    }
    
    private func addVocabulary() {
        let newVocabulary = Vocabulary(word: "", translatedWord: "", wordGroup: .noun)
        //context.insert(newVocabulary)
        list.addVocabulary(newVocabulary)
        
        focusedVocabulary = .word(newVocabulary.id)
        selectedVocabularyIdentifiers = [newVocabulary.id]
    }
    
    private func toggleLearnable(of vocabularies: Array<Vocabulary>) {
        for vocabulary in vocabularies {
            vocabulary.toggleLearnable()
        }
    }
    
    private func checkLearnable(of vocabularies: Array<Vocabulary>) {
        for vocabulary in vocabularies {
            guard !vocabulary.isLearnable else { continue }
            vocabulary.checkLearnable()
        }
    }
    
    private func uncheckLearnable(of vocabularies: Array<Vocabulary>) {
        for vocabulary in vocabularies {
            guard vocabulary.isLearnable else { continue }
            vocabulary.uncheckLearnable()
        }
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

fileprivate struct VocabularyInfoButton: View {
    @Query var tags: Array<Tag>
    
    let vocabulary: Vocabulary
    
    @State var showPopover: Bool = false
    
    var body: some View {
        Button {
            onShowPopover()
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
    
    private func onShowPopover() {
        showPopover = true
    }
}

#Preview {
    ListTableView(list: VocabularyList("Preview List"))
        .previewModelContainer()
}
