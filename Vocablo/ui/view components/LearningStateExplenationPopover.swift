//
//  InfoPopoverButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 11.12.23.
//

import Foundation
import SwiftUI

struct LearningStateExplenationPopover: View {
    @State private var isPopoverShowed = false
    
    var body: some View {
        Button {
            isPopoverShowed.toggle()
        } label: {
            Image(systemName: "questionmark.circle")
                .foregroundStyle(.tertiary)
        }
        .buttonStyle(.plain)
        .popover(isPresented: $isPopoverShowed, content: {
            VStack(spacing: 5){
                Text("What is a learning state?")
                    .font(.subheadline)
                    .bold()
                Text(
                    """
                    It consists the level, how good you can translate the word
                    to the translated word or reversed, and the last repetition.
                    With this attributes the app calculates the next repetition
                    of the word or translated word.
                    """
                )
                .font(.caption)
            }
            .padding()
        })
    }
}
