//
//  String +ext.swift
//  Vocablo
//
//  Created by Marcel Jäger on 01.03.24.
//

import Foundation

extension String {
    func caseInsensitiveContains(_ other: String) -> Bool {
        self.lowercased().contains(other.lowercased())
    }
}
