//
//  Deck.swift
//  Vocablo
//
//  Created by Marcel Jäger on 06.05.24.
//

import Foundation
import SwiftData
import SwiftUI

@Model class Deck {
    var name: String
    var languageOfBase: String
    var languageOfTranslation: String
    
    let created: Date = Date.now
    @Relationship(deleteRule: .nullify, inverse: \Vocabulary.deck) var vocabularies: Array<Vocabulary> = []
    
    //MARK: - Initialiser
    
    init(
        name: String,
        languageOfBase: String,
        languageOfTranslation: String,
        vocabularies: Array<Vocabulary> = []
    ) {
        self.name = name
        self.languageOfBase = languageOfBase
        self.languageOfTranslation = languageOfTranslation
        self.vocabularies = vocabularies
    }
    
    //MARK: - Methods
    
    ///Removes the Vocabulary from the deck.
    ///
    ///> If you remove vocabularies without this methode, the UndoManager will not be able to register the unrelating!
    func remove(vocabulary: Vocabulary) {
        self.vocabularies.removeAll { element in
            element == vocabulary
        }
        
        if let undoManager = self.modelContext?.undoManager {
            undoManager.registerUndo(withTarget: self) { undoList in
                let removedVocabulary = vocabulary
                undoList.vocabularies.append(removedVocabulary)
                undoManager.registerUndo(withTarget: undoList) { redoList in
                    let addedVocabulary = removedVocabulary
                    redoList.remove(vocabulary: addedVocabulary)
                }
            }
        }
    }
}


extension Deck {
    static var new: Deck {
        Deck(name: "New deck", languageOfBase: "", languageOfTranslation: "")
    }
}
