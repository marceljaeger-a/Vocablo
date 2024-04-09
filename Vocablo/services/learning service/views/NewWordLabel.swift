//
//  NewWordLabel.swift
//  Vocablo
//
//  Created by Marcel Jäger on 25.03.24.
//

import Foundation
import SwiftUI

struct NewWordLabel: View {
    var body: some View {
        Text("New word!")
            .font(.headline)
            .fontDesign(.rounded)
            .bold()
            .foregroundStyle(.blue.gradient)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(.blue.opacity(0.2), in: .rect(cornerRadius: 8))
    }
}
