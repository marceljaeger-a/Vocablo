//
//  LearningStateInfoButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 29.11.23.
//

import Foundation
import SwiftUI
import SwiftData

struct LearningStateInfoButton: View {
    
    let vocabulary: Vocabulary
    
    @State private var isPopoverShowed: Bool = false
    
    private func showPopover() {
        isPopoverShowed = true
    }
    
    var body: some View {
        Button {
            showPopover()
        } label: {
            Image(systemName: "info.circle")
        }
        .popover(isPresented: $isPopoverShowed, arrowEdge: .trailing) {
            VStack(alignment: .leading) {
                VStack {
                    LearningStateLabel(vocabulary: vocabulary, state: \.learningState, label: "Word")
                    LearningStateLabel(vocabulary: vocabulary, state: \.translatedLearningState, label: "Translated word")
                }
            }
            .foregroundStyle(.secondary)
            .padding(10)
        }
    }
}



struct LearningStateLabel: View {
    let vocabulary: Vocabulary
    let state: KeyPath<Vocabulary, LearningState>
    let label: String
    
    var body: some View {
        HStack {
            Text(label)
            
            Spacer()
            
            Divider()
            
            Text("\(vocabulary[keyPath: state].currentLevel.rawValue) / \(vocabulary[keyPath: state].remainingTimeLabel)")
        }
    }
}
