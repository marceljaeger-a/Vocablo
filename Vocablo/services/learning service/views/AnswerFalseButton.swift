//
//  AnswerFalseButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 25.03.24.
//

import Foundation
import SwiftUI

struct AnswerFalseButton: View {
    @IndexCard var value: Vocabulary
    
    var previousLevelRepeatingIntervalString: String {
        if let previousLevel = $value.askingLevel.previousLevel() {
            return previousLevel.repeatingIntervalLabel
        }
        return $value.askingLevel.repeatingIntervalLabel
    }
    
    var body: some View {
        Button {
            $value.answerWrong()
        } label: {
            Label(previousLevelRepeatingIntervalString, systemImage: "hand.thumbsdown")
                .foregroundStyle(.red.gradient)
                .frame(width: 65)
        }
    }
}
