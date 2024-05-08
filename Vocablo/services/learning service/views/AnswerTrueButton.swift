//
//  AnswerTrueButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 25.03.24.
//

import Foundation
import SwiftUI

struct AnswerTrueButton: View {
    @IndexCard var value: Vocabulary
    
    var nextLevelRepeatingIntervalString: String {
        if let nextLevel = $value.askingLevel.nextLevel() {
            return nextLevel.repeatingIntervalLabel
        }
        return $value.askingLevel.repeatingIntervalLabel
    }
    
    var body: some View {
        Button {
            $value.answerTrue()
        } label: {
            Label(nextLevelRepeatingIntervalString, systemImage: "hand.thumbsup")
                .foregroundStyle(.green.gradient)
                .frame(width: 65)
        }
    }
}
