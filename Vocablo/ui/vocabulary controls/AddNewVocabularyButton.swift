//
//  NewVocabularyButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 01.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct AddNewVocabularyButton<LabelContent: View>: View {
    
    //MARK: - Dependencies
    
    let deck: Deck?
    var label: () -> LabelContent
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.onAddingVocabularySubject) var onAddingVocabularySubject
    
    //MARK: - Initialiser
    
    init(
        into deck: Deck?,
        label: @escaping () -> LabelContent = { Label("New vocabulary", systemImage: "plus") }
    ) {
        self.deck = deck
        self.label = label
    }
    
    //MARK: - Methods
    
    private func perform() {
        let newVocabulary = Vocabulary.new
        
        if let deck {
            deck.vocabularies.append(newVocabulary)
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
        
        onAddingVocabularySubject.send(newVocabulary)
    }
    
    //MARK: - Body
    
    var body: some View {
        Button {
            perform()
        } label: {
            label()
        }
    }
}
