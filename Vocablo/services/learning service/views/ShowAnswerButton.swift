//
//  ShowAnswerButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 25.03.24.
//

import Foundation
import SwiftUI

struct ShowAnserButton: View {
    @Binding var isAnswerVisible: Bool
    
    var body: some View {
        Button {
            withAnimation {
                isAnswerVisible = true
            }
        } label: {
            Label("Show answer", systemImage: "eye")
                .labelStyle(.titleOnly)
        }
        .buttonStyle(.borderedProminent)
    }
}
