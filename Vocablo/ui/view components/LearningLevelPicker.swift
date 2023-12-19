//
//  LearningLevelPicker.swift
//  Vocablo
//
//  Created by Marcel Jäger on 26.11.23.
//

import Foundation
import SwiftUI

struct LearningLevelPicker: View {
    @Binding var state: LearningState
    
    private func selectLearningState(level: LearningLevel) {
        if state.isNewly {
            state = LearningState.repeatly(.now, 0, level)
        }else {
            state = LearningState.repeatly(state.lastRepetition ?? .now, state.repetitionCount, level)
        }
    }
    
    var body: some View {
        Menu(state.currentLevel.rawValue) {
            ForEach(LearningLevel.allCases, id: \.rawValue) { level in
                Button {
                    selectLearningState(level: level)
                } label: {
                    Text("\(level.rawValue)")
                }
                .disabled(level == state.currentLevel)
            }
        }
        .menuStyle(.borderlessButton)
    }
}
