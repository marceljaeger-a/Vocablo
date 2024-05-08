//
//  FeedbackView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 25.03.24.
//

import Foundation
import SwiftUI

struct FeedbackView: View {
    @IndexCard var value: Vocabulary
    @Binding var isAnswerVisible: Bool
    let wordsLeft: Int
    
    var body: some View {
        VStack(spacing: 10){
            LeftWordsTextView(wordsLeft: wordsLeft)
            
            HStack(spacing: 15){
                if isAnswerVisible == false {
                    ShowAnserButton(isAnswerVisible: $isAnswerVisible)
                }else {
                    AnswerFalseButton(value: $value)
                    
                    AnswerTrueButton(value: $value)
                }
            }
            .buttonStyle(.bordered)
            .controlSize(.extraLarge)
        }
    }
}
