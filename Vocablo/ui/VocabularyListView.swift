//
//  VocabularyListView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 27.11.23.
//

import SwiftUI
import SwiftData

struct VocabularyListView: View {
    @Environment(\.modelContext) var context: ModelContext
    @Query(sort: \Vocabulary.word) var allVocabularies: Array<Vocabulary>
    
    @Bindable var list: VocabularyList
    
    @Binding var selectedVocabularyIDs: Set<PersistentIdentifier> 
    func getVocabularies(ids: Set<PersistentIdentifier>) -> Array<Vocabulary> {
        let vocabularies = list.vocabularies
        return vocabularies.filter { element in
            ids.contains(element.id)
        }
    }
    
    @State var showLearningSheet: Bool = false
    @State var editingVocabulary: Vocabulary?
    
    @FocusState private var textFieldFocus: VocabularyTextFieldFocusState?
    
    @Binding var showVocabulariesDeletingConfirmationDialog: Bool
    
    var body: some View {
        List(list.sortedVocabularies, id: \.id, selection: $selectedVocabularyIDs){ vocabulary in
            VocabularyItem(vocabulary: vocabulary, textFieldFocus: $textFieldFocus)
                .onSubmit {
                    addVocabulary()
                }
        }
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
                    showVocabulariesDeletingConfirmationDialog = true
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
        .toolbar {
            ToolbarItem(placement: .principal) {
                Button {
                    addVocabulary()
                } label: {
                    Image(.wordPlus)
                }
            }
            ToolbarItem(placement: .principal) {
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
        .sheet(item: $editingVocabulary) { vocabulary in
            EditVocabularyView(vocabulary: vocabulary)
        }
    }
    
    private func addVocabulary() {
        let newVocabulary = Vocabulary(word: "", translatedWord: "", wordGroup: .noun)
        list.addVocabulary(newVocabulary)
        textFieldFocus = .word(newVocabulary.id)
        selectedVocabularyIDs = []
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
    
    func openEditVocabularyView(for vocabulary: Vocabulary) {
        editingVocabulary = vocabulary
    }
}

fileprivate enum VocabularyTextFieldFocusState: Hashable{
    case word(PersistentIdentifier), translatedWord(PersistentIdentifier), sentence(PersistentIdentifier), translatedSentenced(PersistentIdentifier)
}

fileprivate struct VocabularyItem: View {
    @Bindable var vocabulary: Vocabulary
    @FocusState.Binding var textFieldFocus: VocabularyTextFieldFocusState?
    
    @State var showLearningStateInfoButton: Bool = false
    var learningStateInfoButtonOpacity: Double {
        if showLearningStateInfoButton {
            return 1
        }else {
            return 0
        }
    }
    
    var body: some View {
        HStack(spacing: 20){
            VocabularyToggle(vocabulary: vocabulary, value: \.isLearnable)
                .toggleStyle(.checkbox)

            VStack(alignment: .leading){
                VocabularyTextField(vocabulary: vocabulary, value: \.word, placeholder: "Word...")
                    .focused($textFieldFocus, equals: VocabularyTextFieldFocusState.word(vocabulary.id))
                
                VocabularyTextField(vocabulary: vocabulary, value: \.sentence, placeholder: "Sentence...")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .focused($textFieldFocus, equals: VocabularyTextFieldFocusState.sentence(vocabulary.id))
            }
            
            Divider()
            
            VStack(alignment: .leading){
                VocabularyTextField(vocabulary: vocabulary, value: \.translatedWord, placeholder: "Translated word..")
                    .focused($textFieldFocus, equals: VocabularyTextFieldFocusState.translatedWord(vocabulary.id))
                
                VocabularyTextField(vocabulary: vocabulary, value: \.translatedSentence, placeholder: "Translated sentence..")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .focused($textFieldFocus, equals: VocabularyTextFieldFocusState.translatedSentenced(vocabulary.id))
            }
            
            LearningStateInfoButton(vocabulary: vocabulary)
                .buttonStyle(.borderless)
                .foregroundStyle(.secondary)
                .opacity(learningStateInfoButtonOpacity)
        }
        .padding(6)
        .textFieldStyle(.plain)
        .autocorrectionDisabled(true)
        .onHover{ hovering in
            withAnimation(.easeInOut) {
                showLearningStateInfoButton = hovering
            }
        }
    }
}

#Preview {
    VocabularyListView( list: VocabularyList("Preview List"), selectedVocabularyIDs: .constant([]), showVocabulariesDeletingConfirmationDialog: .constant(false))
}

