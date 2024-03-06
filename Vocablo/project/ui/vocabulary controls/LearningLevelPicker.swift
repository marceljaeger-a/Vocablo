//
//  LearningLevelPicker.swift
//  Vocablo
//
//  Created by Marcel Jäger on 26.11.23.
//

import Foundation
import SwiftUI

struct LearningLevelPicker: View {
    
    //MARK: - Dependencies
    
    let title: String
    @Binding var level: LearningLevel
    
    //MARK: - Body
    
    var body: some View {
        Picker(title, selection: $level) {
            ForEach(LearningLevel.allCases, id: \.rawValue) { levelCase in
                Text(levelCase.rawValue)
                    .tag(levelCase)
            }
        }
    }
}
