//
//  LearnVocabulariesButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 20.03.24.
//

import Foundation
import SwiftUI

struct LearnVocabulariesButton: View {
    
    //MARK: - Dependencies
    
    let selectedListValue: ListSelectingValue?
    var title: String = "Learn vocabularies"
    
    @Environment(\.learningNavigationModel) var learningNavigationModel
    
    //MARK: - Methods
    
    private func setVocabularies() {
        learningNavigationModel.currentLearningListValue = selectedListValue
    }
    
    private var isDisabled: Bool {
        if selectedListValue == nil {
            return true
        }
        if learningNavigationModel.currentLearningListValue == selectedListValue {
            return true
        }
        return false
    }
    
    //MARK: - Body
    
    var body: some View {
        Button {
            setVocabularies()
        } label: {
            Label(title, image: .wordlistPlay)
        }
        .disabled(isDisabled)
    }
}
