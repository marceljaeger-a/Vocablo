//
//  LearningLevelPicker.swift
//  Vocablo
//
//  Created by Marcel Jäger on 26.11.23.
//

import Foundation
import SwiftUI

//TODO: This picker should set the learningState.
//- if the current is newly -> set the state to repeatly(newLevel , .now) , when you choose a higher level than level 1.
//- if the current is repeatly -> set always to repeatly( newLevel, _)


struct LearningLevelPicker: View {
    @Binding var state: LearningState
    
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
    
    private func selectLearningState(level: LearningLevel) {
        if state.isNewly {
            state = LearningState.repeatly(.now, 0, level)
        }else {
            state = LearningState.repeatly(state.lastRepetition ?? .now, state.repetitionCount, level)
        }
    }
}
