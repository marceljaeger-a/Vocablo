//
//  SearchingText.swift
//  Vocablo
//
//  Created by Marcel Jäger on 13.02.24.
//

import Foundation
import SwiftUI

struct SearchingTextKey: EnvironmentKey {
    static var defaultValue: String = ""
}

extension EnvironmentValues {
    var searchingText: String {
        get {
            self[SearchingTextKey.self]
        }
        set {
            self[SearchingTextKey.self] = newValue
        }
    }
}
