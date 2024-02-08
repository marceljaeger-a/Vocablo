//
//  SelectionContext.swift
//  Vocablo
//
//  Created by Marcel Jäger on 05.01.24.
//

import Foundation
import SwiftUI
import SwiftData



@Observable
class SelectionContext {
    
    //MARK: - Properties
    
    var listSelections: ListSelectionSet = ListSelectionSet()
    var selectedVocabularyIdentifiers: Set<PersistentIdentifier> = []
    
    var bindable: Bindable<SelectionContext> {
        @Bindable var bindableContext = self
        return _bindableContext
    }
    
    ///Returns a boolean if **selectedVocabularyIdentifiers** contains values or not.
    var isAnyVocabularySelected: Bool {
        if selectedVocabularyIdentifiers.isEmpty == false {
            return true
        }
        return false
    }
    
    //MARK: - Methodes
    
    ///Removes the **identifiers** from **selectedVocabularyIdentifiers**.
    ///Returns the removed identifiers those are contained in **selectedVocabularyIdentifiers**.
    func unselectVocabularies(_ identifiers: Set<PersistentIdentifier>) -> Set<PersistentIdentifier> {
        selectedVocabularyIdentifiers.remove(members: identifiers)
    }
    
    ///Removes all identifiers from **selectedVocabularyIdentifiers**.
    ///Returns all identifiers those are contained in **selectedVocabularyIdentifiers**.
    func unselectAllVocabularies() -> Set<PersistentIdentifier> {
        let selectedVocabularies = selectedVocabularyIdentifiers
        selectedVocabularyIdentifiers = []
        return selectedVocabularies
    }
    
    ///Returns a boolean if **selectedVocabularyIdentifiers** contains the **identifier** or not.
    func isVocabularySelected(_ identifier: PersistentIdentifier) -> Bool {
        selectedVocabularyIdentifiers.contains(identifier)
    }
}



//MARK: - EnvrionmentKey

struct SelectionContextEnvrionmentKey: EnvironmentKey {
    static var defaultValue: SelectionContext = SelectionContext()
}



//MARK: - EnvrionmentValue

extension EnvironmentValues {
    var selectionContext: SelectionContext {
        get {
            return self[SelectionContextEnvrionmentKey.self]
        }
        set {
            self[SelectionContextEnvrionmentKey.self] = newValue
        }
    }
}
