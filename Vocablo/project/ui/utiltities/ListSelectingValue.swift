//
//  ListSelectingValue.swift
//  Vocablo
//
//  Created by Marcel Jäger on 29.02.24.
//

import Foundation
import SwiftData

enum ListSelectingValue: Hashable {
    case all
    case model(id: PersistentIdentifier)
    
    var modelIdentifier: PersistentIdentifier? {
        return switch self {
        case .all:
            nil
        case .model(let id):
            id
        }
    }
    
    func fetchList(with modelContext: ModelContext) -> VocabularyList? {
        switch self {
        case .all:
            return nil
        case .model(id: let id):
            let registeredList: VocabularyList? = modelContext.registeredModel(for: id)
            return registeredList
        }
    }
}
