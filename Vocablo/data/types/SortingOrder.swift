//
//  SortingOrder.swift
//  Vocablo
//
//  Created by Marcel Jäger on 12.03.24.
//

import Foundation

enum SortingOrder: Int, CaseIterable {
    case ascending
    case descending
    
    var label: String {
        switch self {
        case .ascending:
            return "Ascending"
        case .descending:
            return "Descending"
        }
    }
    
    var swiftDataOrder: SortOrder {
        switch self {
        case .ascending:
                .forward
        case .descending:
                .reverse
        }
    }
}
