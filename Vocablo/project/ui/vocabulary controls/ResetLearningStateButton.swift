//
//  ResetLearningStateButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 01.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct ResetLearningStateButton: View {
    
    //MARK: - Dependencies
    
    @Binding var state: LearningState
    
    //MARK: - Methods
    
    
    
    //MARK: - Body
    
    var body: some View {
        Button {
            state.reset()
        } label: {
            Text("Reset")
        }
    }
}
