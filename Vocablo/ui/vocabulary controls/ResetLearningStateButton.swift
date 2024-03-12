//
//  ResetLearningStateButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 01.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct ResetLearningStateButton<LabelContent: View>: View {
    
    //MARK: - Dependencies
    
    @Binding var state: LearningState
    var label: () -> LabelContent 
    
    //MARK: - Initialiser
    
    init(
        state: Binding<LearningState>,
        label: @escaping () -> LabelContent = { Text("Reset") }
    ) {
        self._state = state
        self.label = label
    }
    
    //MARK: - Methods
    
    private func perform() {
        state.reset()
    }
    
    //MARK: - Body
    
    var body: some View {
        Button {
            perform()
        } label: {
            label()
        }
    }
}
