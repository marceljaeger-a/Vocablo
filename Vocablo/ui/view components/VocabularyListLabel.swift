//
//  VocabularyListLabel.swift
//  Vocablo
//
//  Created by Marcel Jäger on 01.02.24.
//

import Foundation
import SwiftUI

struct VocabularyListLabel: View {
    let list: VocabularyList
    
    var body: some View {
        Label(list.name, systemImage: "")
            .labelStyle(.titleOnly)
            .foregroundStyle(.tertiary)
    }
}
