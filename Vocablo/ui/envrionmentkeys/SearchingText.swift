//
//  SearchingText.swift
//  Vocablo
//
//  Created by Marcel Jäger on 13.02.24.
//

import Foundation
import SwiftUI

struct SearchingTextEnvironmentKey: EnvironmentKey {
    static var defaultValue: String = ""
}

extension EnvironmentValues {
    var searchingText: String {
        get {
            self[SearchingTextEnvironmentKey.self]
        }
        set {
            self[SearchingTextEnvironmentKey.self] = newValue
        }
    }
}
