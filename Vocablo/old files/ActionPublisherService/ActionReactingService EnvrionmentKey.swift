//
//  ActionPublisherService.swift
//  Vocablo
//
//  Created by Marcel Jäger on 23.01.24.
//

import Foundation
import SwiftUI

struct ActionReactingServiceKey: EnvironmentKey {
    static var defaultValue: ActionReactingService = ActionReactingService()
}

extension EnvironmentValues {
    var actionReactingService: ActionReactingService {
        get {
            self[ActionReactingServiceKey.self]
        }
        set {
            self[ActionReactingServiceKey.self] = newValue
        }
    }
}
