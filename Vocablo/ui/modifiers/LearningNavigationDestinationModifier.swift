//
//  LearningNavigationDestinationModifier.swift
//  Vocablo
//
//  Created by Marcel Jäger on 21.03.24.
//

import Foundation
import SwiftUI
import SwiftData


struct LearningNavigationDestinationModifier: ViewModifier {
    @Environment(\.learningNavigationModel) var learningNavigationModel
    
    func body(content: Content) -> some View {
        content.navigationDestination(isPresented: learningNavigationModel.isLearningDestinationPresented) {
            if let learningListValue = learningNavigationModel.currentLearningListValue {
                LearningDestination(learningListValue: learningListValue)
            }else {
                Color.white
            }
        }
    }
}
