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
    
    //MARK: - Methodes
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
