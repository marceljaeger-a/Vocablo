//
//  NewVocabularyButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 01.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct NewVocabularyButton: View {
    
    //MARK: - Dependencies
    
    let list: VocabularyList?
    
    @Environment(\.modelContext) var modelContext
    
    //MARK: - Methods
    
    private func addNewVocabulary() {
        #warning("The new vocabulary needs to be focused!")
        let newVocabulary = Vocabulary.newVocabulary
        
        if let list {
            list.append(vocabulary: newVocabulary)
            do {
                try modelContext.save()
            }catch {
                print(error.localizedDescription)
            }
        }else {
            modelContext.insert(newVocabulary)
            do {
                try modelContext.save()
            }catch {
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - Body
    
    var body: some View {
        Button {
            addNewVocabulary()
        } label: {
            Label("New vocabulary", systemImage: "plus")
        }
    }
}
