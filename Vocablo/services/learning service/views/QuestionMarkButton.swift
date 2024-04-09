//
//  QuestionMarkButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 25.03.24.
//

import Foundation
import SwiftUI

struct QuestionMarkButton: View {
    @Binding var isAnswerVisible: Bool
    
    var body: some View {
        Button {
            withAnimation {
                isAnswerVisible = true
            }
        } label: {
            Image(systemName: "questionmark")
                .symbolEffect(.pulse)
                .imageScale(.large)
                .font(.largeTitle)
                .fontDesign(.rounded)
                .bold()
        }
        .buttonStyle(.plain)
    }
}
