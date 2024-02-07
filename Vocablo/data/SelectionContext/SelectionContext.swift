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
    
    var isAnyVocabularySelected: Bool {
        if selectedVocabularyIdentifiers.isEmpty == false {
            return true
        }
        return false
    }
    
    //MARK: - Methodes
    
    func unselectVocabularies(_ identifiers: Set<PersistentIdentifier>) -> Set<PersistentIdentifier> {
        selectedVocabularyIdentifiers.remove(members: identifiers)
    }
    
    func unselectAllVocabularies() -> Set<PersistentIdentifier> {
        let selectedVocabularies = selectedVocabularyIdentifiers
        selectedVocabularyIdentifiers = []
        return selectedVocabularies
    }
    
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
