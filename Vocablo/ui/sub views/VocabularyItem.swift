//
//  VocabularyItem.swift
//  Vocablo
//
//  Created by Marcel Jäger on 14.12.23.
//

import Foundation
import SwiftUI
import SwiftData


////MARK: - Types
//
//enum VocabularyTextFieldFocusState: Hashable{
//    case word(PersistentIdentifier), translatedWord(PersistentIdentifier), sentence(PersistentIdentifier), translatedSentenced(PersistentIdentifier)
//}
//
//
//
//struct VocabularyItem: View {
//    
//    //MARK: - Properties
//    
//    @Bindable var vocabulary: Vocabulary
//    @FocusState.Binding var textFieldFocus: VocabularyTextFieldFocusState?
//    let isDuplicateRecognitionLabelAvailable: Bool
//    let isListLabelAvailable: Bool
//    
//    @Environment(\.modelContext) var modelContext
//    @Environment(\.refresh) var refreshAction
//    
//    @State private var isLearningStateInfoButtonShowed: Bool = false
//    @State private var hasDuplicates: Bool = false
//    
//    private var learningStateInfoButtonOpacity: Double {
//        if isLearningStateInfoButtonShowed {
//            return 1
//        }else {
//            return 0
//        }
//    }
//    
//    //MARK: - Methods
//    
//    private func fetchDuplicateCount() async -> Int {
//        let count = try? modelContext.fetchCount(.duplicatesOf(vocabulary))
//        return count ?? 0
//    }
//    
//    private func setHasDuplicates() async {
//        async let count = fetchDuplicateCount()
//        
//        if await count > 0 {
//            hasDuplicates = true
//        }else {
//            hasDuplicates = false
//        }
//    }
//    
//    //MARK: - Body
//    
//    var body: some View {
//        HStack(spacing: 20){
//            VStack(spacing: 10){
//                HStack {
//                    wordAndSentenceVStack
//                    
//                    Divider()
//                    
//                    translatedWordAndSentenceVStack
//                }
//                
//                HStack(spacing: 20) {
//                    Label(vocabulary.isToLearn ? "To learn" : "Not to learn", systemImage: vocabulary.isToLearn ? "checkmark" : "xmark")
//                        .labelStyle(.titleOnly)
//                        .foregroundStyle(vocabulary.isToLearn ? AnyShapeStyle(Color.green) : AnyShapeStyle(.tertiary))
//                    
//                    if isListLabelAvailable, let list = vocabulary.list {
//                        Label(list.name, systemImage: "")
//                            .labelStyle(.titleOnly)
//                            .foregroundStyle(.tertiary)
//                    }
//                    if hasDuplicates && isDuplicateRecognitionLabelAvailable {
//                        DuplicateVocabulariesPopoverButton(duplicatesOf: vocabulary, within: nil)
//                            .buttonStyle(.plain)
//                    }
//                    Spacer()
//                }
//                .task {
//                    if isDuplicateRecognitionLabelAvailable {
//                        await setHasDuplicates()
//                    }
//                }
//                .onChange(of: [vocabulary.baseWord, vocabulary.baseSentence, vocabulary.translationWord, vocabulary.translationSentence]) { oldValue, newValue in
//                    if isDuplicateRecognitionLabelAvailable {
//                        Task {
//                            await setHasDuplicates()
//                        }
//                    }
//                }
//            }
//        }
//        .padding(6)
//        .textFieldStyle(.plain)
//        .autocorrectionDisabled(true)
//        .onHover{ isHovering in
//            withAnimation(.easeInOut) {
//                isLearningStateInfoButtonShowed = isHovering
//            }
//        }
//    }
//}
//
//
//
////MARK: - Subviews
//
//extension VocabularyItem {
//    var wordAndSentenceVStack: some View {
//        VStack(alignment: .leading){
//            TextField("", text: $vocabulary.baseWord, prompt: Text("Word..."))
//                .font(.headline)
//                .focused($textFieldFocus, equals: VocabularyTextFieldFocusState.word(vocabulary.id))
//            
//            TextField("", text: $vocabulary.baseSentence, prompt: Text("Sentence..."))
//                .foregroundStyle(.secondary)
//                .focused($textFieldFocus, equals: VocabularyTextFieldFocusState.sentence(vocabulary.id))
//        }
//    }
//    
//    var translatedWordAndSentenceVStack: some View {
//        VStack(alignment: .leading){
//            TextField("", text: $vocabulary.translationWord, prompt: Text("Translated word..."))
//                .font(.headline)
//                .focused($textFieldFocus, equals: VocabularyTextFieldFocusState.translatedWord(vocabulary.id))
//            
//            TextField("", text: $vocabulary.translationSentence, prompt: Text("Translated sentence..."))
//                .foregroundStyle(.secondary)
//                .focused($textFieldFocus, equals: VocabularyTextFieldFocusState.translatedSentenced(vocabulary.id))
//        }
//    }
//}
