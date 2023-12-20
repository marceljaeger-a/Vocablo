//
//  LearningLevelPicker.swift
//  Vocablo
//
//  Created by Marcel Jäger on 26.11.23.
//

import Foundation
import SwiftUI

struct LearningLevelPicker: View {
    @Binding var level: LearningLevel
    
    private func selectLearningState(selection: LearningLevel) {
        self.level = selection
    }
    
    var body: some View {
        Menu(level.rawValue) {
            ForEach(LearningLevel.allCases, id: \.rawValue) { levelCase in
                Button {
                    selectLearningState(selection: levelCase)
                } label: {
                    Text("\(levelCase.rawValue)")
                }
                .disabled(levelCase == level)
            }
        }
        .menuStyle(.borderlessButton)
    }
}
