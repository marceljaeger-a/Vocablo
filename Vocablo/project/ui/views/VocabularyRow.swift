//
//  VocabularyView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 29.02.24.
//

import Foundation
import SwiftUI
import SwiftData

struct VocabularyRow: View {
    
    //MARK: - Dependencies
    
    @Bindable var vocabulary: Vocabulary
    @FocusState.Binding var focusedTextField: FocusedVocabularyTextField?
    
    //MARK: - Body
    
    var body: some View {
        Grid(alignment: .leading ,horizontalSpacing: 25){
            GridRow {
                //FIXME: The TextField is one reason of the hang while opening a DetailView. The run 13 in Instruments is without TextField.
                //And the run 14 is with TextFields.
                TextField("", text: $vocabulary.baseWord, prompt: Text("Word..."))
                    .focused($focusedTextField, equals: .baseWord(vocabularyIdentifier: vocabulary.id))
                
                TextField("", text: $vocabulary.translationWord, prompt: Text("Translated word..."))
                    .focused($focusedTextField, equals: .translationWord(vocabularyIdentifier: vocabulary.id))
            }
            .font(.headline)
            
            GridRow {
                TextField("", text: $vocabulary.baseSentence, prompt: Text("Sentence..."))
                    .focused($focusedTextField, equals: .baseSentence(vocabularyIdentifier: vocabulary.id))
                
                TextField("", text: $vocabulary.translationSentence, prompt: Text("Translated sentence..."))
                    .focused($focusedTextField, equals: .translationSentence(vocabularyIdentifier: vocabulary.id))
            }
            .foregroundStyle(.secondary)
            
            GridRow {
                VocabularyInfoGridRowContent(vocabulary: vocabulary)
                    .gridCellColumns(2)
            }
        }
        .textFieldStyle(.plain)
        .padding(5)
    }
}



struct VocabularyInfoGridRowContent: View {
    let vocabulary: Vocabulary
    
    var list: VocabularyList? {
        vocabulary.list
    }
    
    var body: some View {
        HStack(spacing: 20) {
            if vocabulary.isToLearn {
                Label("To learn", systemImage: "checkmark")
                    .labelStyle(.titleOnly)
                    .foregroundStyle(.tertiary)
            }
            
            if let list {
                Label(list.name, systemImage: "")
                    .labelStyle(.titleOnly)
                    .foregroundStyle(.tertiary)
            }
            
            Spacer()
        }
    }
}
