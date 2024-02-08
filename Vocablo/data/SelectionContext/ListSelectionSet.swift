//
//  ListSelectionSet.swift
//  Vocablo
//
//  Created by Marcel Jäger on 07.02.24.
//

import Foundation
import SwiftData

struct ListSelectionSet {
    
    ///The current selected lists in the sidebar.
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
    
    ///Returns a boolean if the **selections** property has values.
    var isAnySelected: Bool {
        selections.isEmpty == false
    }
    
    ///Removes the **value** from the **selections**.
    ///Return the **value** if the **selections** contained it.
    mutating func unselect(_ value: ListSelectionValue) -> ListSelectionValue? {
        selections.remove(value)
    }
    
    ///Removes all values from the **selections**.
    ///Returns the contained values from the **selections**
    mutating func unselectAll() -> Set<ListSelectionValue> {
        selections.remove(members: selections)
    }
    
    ///Insert the **value** into the **selections**.
    mutating func select(_ value: ListSelectionValue) {
        selections.insert(value)
    }
    
    ///Returns a boolean if **selections** contains the value or not.
    func isSelected(_ value: ListSelectionValue) -> Bool {
        selections.contains(value)
    }
}



extension ListSelectionSet {
    ///Initialize an instance by the given **set**.
    init(set: Set<PersistentIdentifier>) {
        self.init()
        
        self.selections = Set(set.map { return ListSelectionValue.list(identifier: $0) })
    }
    
    ///Initialize an instance by the given **set**.
    init(values: Set<ListSelectionValue>) {
        self.init()
        
        self.selections = values
    }
    
    ///Returns values those are contained in the **newSet** but not conatained in the **oldSet**.
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
    ///Returns the identifiers of **list**s those are contained in **selections.**
    ///If **selections** does not contain any **list** it returns nil.
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
    
    ///Returns a boolean if **selections** contains **allVocabularies**.
    var isAllVocabulariesSelected: Bool {
        selections.contains(.allVocabularies)
    }
    
    ///Returns a boolean if **selections** contains **duplicates**.
    var isDuplicatesSelected: Bool {
        selections.contains(.duplicates)
    }
    
    ///Returns a boolean if **selections** contains any **list**.
    var isAnyListSelected: Bool {
        guard let listIdentifiers else { return false }
        return listIdentifiers.isEmpty == false
    }
    
    ///Returns the count of all contained **list**s in **selections**.
    var listCount: Int {
        listIdentifiers?.count ?? 0
    }
    
    ///Removes **list**s by the **identifiers** from **selections**.
    ///Returns the contained **list**s those are being removed.
    mutating func unselectLists(_ identifiers: Set<PersistentIdentifier>) -> Set<PersistentIdentifier> {
        var unselectedListIdentifiers = Set<PersistentIdentifier>()
        for identifier in identifiers {
            if let unselectedListValue = unselect(.list(identifier: identifier)), case .list(let identifier) = unselectedListValue {
                unselectedListIdentifiers.insert(identifier)
            }
        }
        
        return unselectedListIdentifiers
    }
    
    ///Removes all **list**s from **selections**.
    ///Returns the contained **list**s.
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
    
    ///Returns a boolean if **selections** contains a **list** by this **identifier** or not.
    func isListSelected(_ identifier: PersistentIdentifier) -> Bool {
        isSelected(.list(identifier: identifier))
    }
}

