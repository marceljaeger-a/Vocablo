//
//  LearningNavigationModel.swift
//  Vocablo
//
//  Created by Marcel Jäger on 20.03.24.
//

import Foundation
import SwiftUI
import SwiftData

@Observable class LearningNavigationModel {
    var currentLearningListValue: ListSelectingValue?

    var isLearningDestinationPresented: Binding<Bool> {
        Binding {
            if self.currentLearningListValue == nil {
                return false
            }
            else {
                return true
            }
        } set: { newValue in
            if newValue == false {
                self.currentLearningListValue = nil
            }
        }

    }
}

struct LearningNavigationModelKey: EnvironmentKey {
    static var defaultValue = LearningNavigationModel()
}

extension EnvironmentValues {
    var learningNavigationModel: LearningNavigationModel {
        get {
            self[LearningNavigationModelKey.self]
        }
    }
}
