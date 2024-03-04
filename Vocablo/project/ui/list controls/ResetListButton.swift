//
//  ResetListButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 04.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct ResetListButton: View {
    
    //MARK: - Dependencies
    
    var title = "Reset"
    let list: VocabularyList?
    
    @Environment(\.modelContext) var modelContext
    
    //MARK: - Methods
    
    
    
    //MARK: - Body
    
    var body: some View {
        Button {
            guard let list else { return }
            let fetchedVocabulariesOfList = modelContext.fetchVocabularies(.vocabularies(of: list))
            fetchedVocabulariesOfList.forEach { vocabulary in
                vocabulary.resetLearningsStates()
            }
        } label: {
            Text(title)
        }
    }
}
