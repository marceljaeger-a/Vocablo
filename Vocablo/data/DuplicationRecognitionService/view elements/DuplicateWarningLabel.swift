//
//  DuplicationLabel.swift
//  Vocablo
//
//  Created by Marcel Jäger on 30.01.24.
//

import Foundation
import SwiftUI

struct DuplicateWarningLabel: View {
    var body: some View {
        Label("Show Duplicates", image: .duplicateWarning)
            .symbolRenderingMode(.multicolor)
            .foregroundStyle(.yellow)
    }
}

#Preview {
    DuplicateWarningLabel()
}
