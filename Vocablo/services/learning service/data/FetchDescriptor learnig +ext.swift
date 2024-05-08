//
//  FetchDescriptor New +ext.swift
//  Vocablo
//
//  Created by Marcel Jäger on 20.03.24.
//

import Foundation
import SwiftData
import SwiftUI

extension FetchDescriptor {
    static func learningVocabularies(of learningListValue: DeckSelectingValue) -> FetchDescriptor<Vocabulary> {
        switch learningListValue {
        case .all:
            return FetchDescriptor<Vocabulary>(predicate: #Predicate { vocabulary in
                vocabulary.isToLearn == true
            })
        case .deck(let list):
            let listID = list.persistentModelID
            let predicate: Predicate<Vocabulary> = #Predicate { vocabulary in
                ( listID == vocabulary.deck?.persistentModelID ) && ( vocabulary.isToLearn == true )
            }
            return FetchDescriptor<Vocabulary>(predicate: predicate)
        }
    }
}
