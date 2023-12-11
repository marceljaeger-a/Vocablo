//
//  InfoPopoverButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 11.12.23.
//

import Foundation
import SwiftUI

struct InfoPopoverButton: View {
    @State var showPopover = false
    
    var body: some View {
        Button {
            showPopover.toggle()
        } label: {
            Image(systemName: "questionmark.circle")
                .foregroundStyle(.tertiary)
        }
        .buttonStyle(.plain)
        .popover(isPresented: $showPopover, content: {
            VStack(spacing: 5){
                Text("What is a learning state?")
                    .font(.subheadline)
                    .bold()
                Text(
                    """
                    It consists the level, how good you can translate the word,
                    and the last repetition.
                    With this attributes the app calculates the next repetition 
                    of the word.
                    """
                )
                .font(.caption)
            }
            .padding()
        })
    }
}
