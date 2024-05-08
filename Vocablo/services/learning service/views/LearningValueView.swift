//
//  LearningValueView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 21.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct LearningValueView: View {
    
    //MARK: - Dependencies
    
    ///Every new instance of LearningValue is unique because of the Identifable conformance. So the body will run, if you initialise a new View value!
    @IndexCard var value: Vocabulary
    let learningValuesCount: Int
    
    @State var isAnswerVisible: Bool = false
    
    var answeringContextViewOpacity: Double {
        if isAnswerVisible {
            return 1.0
        }else {
            return 0.0
        }
    }
    
    var answeringContextViewOverlayOpacity: Double {
        if isAnswerVisible {
            return 0.0
        }else {
            return 1.0
        }
    }
    
    var newWordLabelOpacity: Double {
        switch _value.isNew{
        case true:
            return 1.0
        case false:
            return 0.0
        }
    }
    
    //MARK: - Initialiser
    
    init(of learningValue: IndexCard<Vocabulary>, learningValuesCount: Int) {
        self._value = learningValue
        self.learningValuesCount = learningValuesCount
    }
 
    //MARK: - Body
    
    var body: some View {
        let _ = Self._printChanges()
        
        VStack {
            NewWordLabel()
                .opacity(newWordLabelOpacity)
            
            Spacer()
            
            LearningContextView(word: $value.askingPrimaryContent, sentence: $value.askingSecondaryContent)
            
            Spacer()
            
            Divider()
            
            Spacer()
            
            LearningContextView(word: $value.answeringPrimaryContent, sentence: $value.answeringSecondaryContent)
                .opacity(answeringContextViewOpacity)
                .overlay {
                    QuestionMarkButton(isAnswerVisible: $isAnswerVisible)
                        .opacity(answeringContextViewOverlayOpacity)
                }
            
            Spacer()
            
            FeedbackView(value: $value, isAnswerVisible: $isAnswerVisible, wordsLeft: learningValuesCount)
        }
        .padding()
        .focusedSceneValue(\.learningValue, $value)
        .focusedSceneValue(\.isAnswerVisible, $isAnswerVisible)
        .onChange(of: $value) {
            isAnswerVisible = false
        }
    }
}
