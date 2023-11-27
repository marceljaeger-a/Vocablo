//
//  VocabularyToggle.swift
//  Vocablo
//
//  Created by Marcel Jäger on 26.11.23.
//

import Foundation
import SwiftUI

struct VocabularyToggle: View {
    @Bindable var vocabulary: Vocabulary
    var value: KeyPath<Bindable<Vocabulary>, Binding<Bool>>
    var label: Text?
    
    var body: some View {
        Toggle(isOn: $vocabulary[keyPath: value]) {
            if let label {
                label
            }
        }
    }
}
