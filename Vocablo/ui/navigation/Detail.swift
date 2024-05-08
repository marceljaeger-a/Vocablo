//
//  Detail.swift
//  Vocablo
//
//  Created by Marcel Jäger on 29.02.24.
//

import Foundation
import SwiftUI
import SwiftData

struct Detail: View {
    
    //MARK: - Dependencies
    
    @Binding var selectedDeckValue: DeckSelectingValue
    
    //MARK: - Body
    
    var body: some View {
        let _ = Self._printChanges()
        NavigationStack {
            VocabulariesDestination(selectedDeckValue: $selectedDeckValue)
                .modifier(LearningNavigationDestinationModifier())
        }
        
    }
}
