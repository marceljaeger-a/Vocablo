//
//  ListSelectionSet.swift
//  Vocablo
//
//  Created by Marcel Jäger on 07.02.24.
//

import Foundation
import SwiftData

struct ListSelectionSet {
    var selections: Set<ListSelectionValue> = [] {
        didSet {
            if insertedValues(oldSet: oldValue, newSet: selections).contains(.allVocabularies) {
                
                for selection in selections {
                    if case .list(identifier: _) = selection {
                        selections.remove(selection)
                    }else if case .duplicates = selection {
                        selections.remove(selection)
                    }
                }
                
            }else if insertedValues(oldSet: oldValue, newSet: selections).contains(.duplicates) {
                
                for selection in selections {
                    if case .list(identifier: _) = selection {
                        selections.remove(selection)
                    }else if case .allVocabularies = selection {
                        selections.remove(selection)
                    }
                }
                
            } else if ( oldValue.contains(.allVocabularies) || oldValue.contains(.duplicates) ) && insertedValues(oldSet: oldValue, newSet: selections).contains(where: { insertedValue in
                if case .list(identifier: _) = insertedValue {
                    return true
                }
                return false
            })
            {
                _ = self.unselect(.allVocabularies)
                _ = self.unselect(.duplicates)
            }
        }
    }
    
    mutating func unselect(_ value: ListSelectionValue) -> ListSelectionValue? {
        selections.remove(value)
    }
    
    mutating func unselectAll() -> Set<ListSelectionValue> {
        selections.remove(members: selections)
    }
    
    mutating func select(_ value: ListSelectionValue) {
        selections.insert(value)
    }
    
    func isSelected(_ value: ListSelectionValue) -> Bool {
        selections.contains(value)
    }
    
    var isAnySelected: Bool {
        selections.isEmpty == false
    }
}



extension ListSelectionSet {
    init(set: Set<PersistentIdentifier>) {
        self.init()
        
        self.selections = Set(set.map { return ListSelectionValue.list(identifier: $0) })
    }
    
    init(values: Set<ListSelectionValue>) {
        self.init()
        
        self.selections = values
    }
    
    private func insertedValues(oldSet: Set<ListSelectionValue>, newSet: Set<ListSelectionValue>) -> Set<ListSelectionValue> {
        var newValues = Set<ListSelectionValue>()
        
        for new in newSet {
            if oldSet.contains(new) == false {
                newValues.insert(new)
            }
        }
        
        return newValues
    }
}



extension ListSelectionSet {
    var listIdentifiers: Set<PersistentIdentifier>? {
        var identifiers: Set<PersistentIdentifier> = []
        for selection in selections {
            switch selection {
            case .list(let identifier):
                identifiers.insert(identifier)
            default:
                break
            }
        }
        
        guard identifiers.isEmpty == false else { return nil }
        return identifiers
    }
    
    var isAllVocabulariesSelected: Bool {
        selections.contains(.allVocabularies)
    }
    
    var isDuplicatesSelected: Bool {
        selections.contains(.duplicates)
    }
    
    var isAnyListSelected: Bool {
        guard let listIdentifiers else { return false }
        return listIdentifiers.isEmpty == false
    }
    
    var listCount: Int {
        listIdentifiers?.count ?? 0
    }
    
    mutating func unselectLists(_ identifiers: Set<PersistentIdentifier>) -> Set<PersistentIdentifier> {
        var unselectedListIdentifiers = Set<PersistentIdentifier>()
        for identifier in identifiers {
            if let unselectedListValue = unselect(.list(identifier: identifier)), case .list(let identifier) = unselectedListValue {
                unselectedListIdentifiers.insert(identifier)
            }
        }
        
        return unselectedListIdentifiers
    }
    
    mutating func unselectAllLists() -> Set<PersistentIdentifier> {
        var unselectedListIdentifers = Set<PersistentIdentifier>()
        
        for selection in selections {
            if case .list(let identifier) = selection {
                if let unselectedList = unselect(selection) {
                    unselectedListIdentifers.insert(identifier)
                }
            }
        }
        
        return unselectedListIdentifers
    }
    
    func isListSelected(_ identifier: PersistentIdentifier) -> Bool {
        isSelected(.list(identifier: identifier))
    }
}

