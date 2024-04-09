//
//  LearningContextView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 25.03.24.
//

import Foundation
import SwiftUI

struct LearningContextView: View {
    let word: String
    let sentence: String
    
    var body: some View {
        VStack(spacing: 25){
            Text(word)
                .font(.largeTitle)
                .fontDesign(.rounded)
                .bold()
            
            Text(sentence)
                .font(.title3)
                .fontDesign(.rounded)
                .foregroundStyle(.secondary)
        }
    }
}
