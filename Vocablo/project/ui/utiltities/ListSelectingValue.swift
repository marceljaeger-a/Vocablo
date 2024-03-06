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
    case list(list: VocabularyList)
    
    var list: VocabularyList? {
        return switch self {
        case .all:
            nil
        case .list(let list):
            list
        }
    }
}
