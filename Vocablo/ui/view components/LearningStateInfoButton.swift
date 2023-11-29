//
//  LearningStateInfoButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 29.11.23.
//

import Foundation
import SwiftUI
import SwiftData

fileprivate struct LearningStateLabel: View {
    let vocabulary: Vocabulary
    let learningState: KeyPath<Vocabulary, LearningState>
    let label: String
    
    var body: some View {
        HStack {
            Text(label)
            
            Spacer()
            
            Divider()
            
            Text("\(vocabulary[keyPath: learningState].currentLevel.rawValue) / \(vocabulary[keyPath: learningState].remainingTimeLabel)")
        }
    }
}

struct LearningStateInfoButton: View {
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
                LearningStateLabel(vocabulary: vocabulary, learningState: \.learningState, label: "Word")
                LearningStateLabel(vocabulary: vocabulary, learningState: \.translatedLearningState, label: "Translated word")
            }
        }
        .foregroundStyle(.secondary)
        .padding(10)
    }
    
    private func onShowPopover() {
        showPopover = true
    }
}
