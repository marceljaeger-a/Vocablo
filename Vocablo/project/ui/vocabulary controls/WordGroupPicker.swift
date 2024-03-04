//
//  WordGroupPicker.swift
//  Vocablo
//
//  Created by Marcel Jäger on 01.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct WordGroupPicker: View {
    
    //MARK: - Dependencies
    
    let title: String
    @Binding var group: WordGroup
    
    //MARK: - Methods
    
    
    
    //MARK: - Body
    
    var body: some View {
        Picker(title, selection: $group) {
            ForEach(WordGroup.allCases, id: \.rawValue) { wordGroup in
                Text(wordGroup.rawValue)
                    .tag(wordGroup)
            }
        }
    }
}


