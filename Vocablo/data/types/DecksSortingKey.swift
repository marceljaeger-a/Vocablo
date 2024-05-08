//
//  ListSorting.swift
//  Vocablo
//
//  Created by Marcel Jäger on 12.03.24.
//

import Foundation

enum DecksSortingKey: Int, CaseIterable{
    case createdDate
    case name
    
    var label: String {
        switch self {
        case .createdDate:
            return "Date created"
        case .name:
            return "Name"
        }
    }
}

