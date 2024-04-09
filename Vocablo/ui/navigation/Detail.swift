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
    
    @Binding var selectedList: ListSelectingValue
    
    //MARK: - Body
    
    var body: some View {
        let _ = Self._printChanges()
        NavigationStack {
            VocabulariesDestination(selectedList: $selectedList)
                .modifier(LearningNavigationDestinationModifier())
        }
        
    }
}
