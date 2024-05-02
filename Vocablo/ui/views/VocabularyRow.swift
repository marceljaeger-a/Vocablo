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
    let isSelected: Bool
    
    //MARK: - Body
    
    var body: some View {
        let _ = Self._printChanges()
        Grid(alignment: .leading ,horizontalSpacing: 25, verticalSpacing: 5){
            GridRow{
                FitedTextView(value: vocabulary.baseWord, placeholder: "Word, ...")
                FitedTextView(value: vocabulary.translationWord, placeholder: "Word, ...")
            }
            .font(.headline)
            .lineLimit(1)
            
            GridRow(alignment: .firstTextBaseline) {
                FitedTextView(value: vocabulary.baseSentence, placeholder: "Sample sentence, explenation, ...")
                    .fixedSize(horizontal: false, vertical: true)
                    
                FitedTextView(value: vocabulary.translationSentence, placeholder: "Sample sentence, explenation, ...")
                    .fixedSize(horizontal: false, vertical: true)
            }
            .lineLimit(2)
            
            VocabularyInfoGridRowContent(vocabulary: vocabulary, isSelected: isSelected)
        }
        .padding(5)
    }
}

extension VocabularyRow {
    struct FitedTextView: View {
        let value: String
        let placeholder: String
        
        var text: String {
            if value.isEmpty {
                return placeholder
            }else {
                return value
            }
        }
        
        var body: some View {
            HStack {
                Text(text)
                    .foregroundStyle(value.isEmpty ? .tertiary : .primary)
                Spacer()
            }
        }
    }
}


struct VocabularyInfoGridRowContent: View {
    let vocabulary: Vocabulary
    let isSelected: Bool
    
    @Environment(\.selectedListValue) var selectedListValue: ListSelectingValue
    
    var listOfVocabulary: VocabularyList? {
        vocabulary.list
    }
    
    var isListNameLabelVisible: Bool {
        if case ListSelectingValue.all = selectedListValue {
            return true
        }
        return false
    }
    
    var body: some View {
        HStack(spacing: 20){
            if vocabulary.isToLearn {
                Label("To learn", systemImage: "checkmark")
                    .labelStyle(.titleOnly)
                    .foregroundStyle(isSelected ? AnyShapeStyle(.primary) : AnyShapeStyle(Color.accentColor))
            }
            
            if let listOfVocabulary, isListNameLabelVisible == true {
                Label(listOfVocabulary.name, systemImage: "")
                    .labelStyle(.titleOnly)
                    .foregroundStyle(.tertiary)
            }
            
            Spacer()
        }
    }
}
