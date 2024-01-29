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
    
    var selectedListIdentifiers: Set<PersistentIdentifier> = []
    var selectedVocabularyIdentifiers: Set<PersistentIdentifier> = []
    
    var bindable: Bindable<SelectionContext> {
        @Bindable var bindableContext = self
        return _bindableContext
    }
    
    var isAnyListSelected: Bool {
        if selectedListIdentifiers.isEmpty == false {
            return true
        }
        return false
    }
    
    var isAnyVocabularySelected: Bool {
        if selectedVocabularyIdentifiers.isEmpty == false {
            return true
        }
        return false
    }
    
    //MARK: - Methodes
    
    func unselectLists(_ identifiers: Set<PersistentIdentifier>) -> Set<PersistentIdentifier> {
        selectedListIdentifiers.remove(members: identifiers)
    }
    
    func unselectVocabularies(_ identifiers: Set<PersistentIdentifier>) -> Set<PersistentIdentifier> {
        selectedVocabularyIdentifiers.remove(members: identifiers)
    }
    
    func unselectAllLists() -> Set<PersistentIdentifier> {
        let selectedLists = selectedListIdentifiers
        selectedListIdentifiers = []
        return selectedLists
    }
    
    func unselectAllVocabularies() -> Set<PersistentIdentifier> {
        let selectedVocabularies = selectedVocabularyIdentifiers
        selectedVocabularyIdentifiers = []
        return selectedVocabularies
    }
    
    func isListSelected(_ identifier: PersistentIdentifier) -> Bool {
        selectedListIdentifiers.contains(identifier)
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
    var selections: SelectionContext {
        get {
            return self[SelectionContextEnvrionmentKey.self]
        }
        set {
            self[SelectionContextEnvrionmentKey.self] = newValue
        }
    }
}



//MARK: - Scene & View Modifier

extension Scene {
    func selectionContext(_ context: SelectionContext) -> some Scene {
        self.environment(\.selections, context)
    }
}

extension View {
    func selectionContext(_ context: SelectionContext) -> some View {
        self.environment(\.selections, context)
    }
}
