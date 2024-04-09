//
//  AnswerFalseButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 25.03.24.
//

import Foundation
import SwiftUI

struct AnswerFalseButton: View {
    @LearningValue var value: Vocabulary
    
    var previousLevelRepeatingIntervalString: String {
        $value.askingState.previousLevel.repeatingIntervalLabel
    }
    
    var body: some View {
        Button {
            $value.answerFalse()
        } label: {
            Label(previousLevelRepeatingIntervalString, systemImage: "hand.thumbsdown")
                .foregroundStyle(.red.gradient)
                .frame(width: 65)
        }
    }
}
