//
//  VocabularyTextField.swift
//  Vocablo
//
//  Created by Marcel Jäger on 26.11.23.
//

import Foundation
import SwiftUI

struct VocabularyTextField: View {
    @Bindable var vocabulary: Vocabulary
    let value: KeyPath<Bindable<Vocabulary>, Binding<String>>
    let placeholder: String
    
    var body: some View {
        TextField("", text: $vocabulary[keyPath: value], prompt: Text(placeholder))
    }
}

