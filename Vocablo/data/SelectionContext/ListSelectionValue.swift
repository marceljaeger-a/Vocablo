//
//  ListSelectionValue.swift
//  Vocablo
//
//  Created by Marcel Jäger on 07.02.24.
//

import Foundation
import SwiftData

enum ListSelectionValue: Hashable {
    case list(identifier: PersistentIdentifier)
    case allVocabularies
    case duplicates
}
