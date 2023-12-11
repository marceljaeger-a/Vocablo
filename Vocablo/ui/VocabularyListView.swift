//
//  VocabularyListView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 27.11.23.
//

import SwiftUI
import SwiftData

struct VocabularyListView: View {
    @Bindable var list: VocabularyList
    @Binding var selectedVocabularyIDs: Set<PersistentIdentifier>
    
    @Environment(\.modelContext) var context: ModelContext
    
    @Binding var showLearningSheet: Bool 
    @State var editingVocabulary: Vocabulary?
    
    @FocusState private var textFieldFocus: VocabularyTextFieldFocusState?
    
    var body: some View {
        List(list.sortedVocabularies, id: \.id, selection: $selectedVocabularyIDs){ vocabulary in
            VocabularyItem(vocabulary: vocabulary, textFieldFocus: $textFieldFocus)
                .onSubmit {
                    list.addNewVocabulary()
                }
        }
        .contextMenu(forSelectionType: Vocabulary.ID.self, menu: { vocabularyIDs in
            if vocabularyIDs.isEmpty {
                Button {
                    list.addNewVocabulary()
                } label: {
                    Text("New vocabulary")
                }
            }else {
                if vocabularyIDs.count == 1 {
                    Button {
                        guard let firstVocabulary: Vocabulary = context.fetch(ids: vocabularyIDs).first else { return }
                        openEditVocabularyView(for: firstVocabulary)
                    } label: {
                        Text("Edit")
                    }
                    
                    Divider()
                }
                
                Button {
                    context.toLearn(for: context.fetch(ids: vocabularyIDs))
                } label: {
                    Text("To learn")
                }
            
                Button {
                    context.notToLearn(for: context.fetch<Vocabulary>(ids: vocabularyIDs))
                } label: {
                    Text("Not to learn")
                }
                
                Button {
                    context.resetVocabularies(context.fetch(ids:vocabularyIDs))
                } label: {
                    if vocabularyIDs.count == 1 {
                        Text("Reset")
                    }else {
                        Text("Reset selected")
                    }
                }
                
                Divider()
                
                Button {
                    context.deleteVocabularies(context.fetch(ids: vocabularyIDs))
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
                guard let firstVocabulary: Vocabulary = context.fetch(ids: vocabularyIDs).first else { return }
                openEditVocabularyView(for: firstVocabulary)
            }
        })
        .toolbar {
            ToolbarItem(placement: .principal) {
                Button {
                    list.addNewVocabulary()
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
            LearnView(list: list)
        })
        .sheet(item: $editingVocabulary) { vocabulary in
            EditVocabularyView(vocabulary: vocabulary)
        }
        .onAddVocabulary(to: list, action: { newVocabulary in
            textFieldFocus = nil //This helps for the "AttributeGraph" message!
            selectedVocabularyIDs = []
            selectedVocabularyIDs.insert(newVocabulary.id) //This causes an "AttributeGraph" message!
            Task { //This helps for the nonfocsuing, when an other list is focued, while I add a new list.
                textFieldFocus = .word(newVocabulary.id)
            }
        })
    }
    
    private func openEditVocabularyView(for vocabulary: Vocabulary) {
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
    VocabularyListView( list: VocabularyList("Preview List"), selectedVocabularyIDs: .constant([]), showLearningSheet: .constant(false))
}

