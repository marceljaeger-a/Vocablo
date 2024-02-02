//
//  SettingsScene.swift
//  Vocablo
//
//  Created by Marcel Jäger on 15.12.23.
//

import Foundation
import SwiftUI

struct SettingsScene: Scene {

    @Environment(\.sheetContext) var sheetContext
    
    var body: some Scene {
        Settings {
            Form {
                Toggle("Show welcome sheet", isOn: sheetContext.bindable.isWelcomeSheetShown)
            }
            .formStyle(.grouped)
            .padding()
        }
    }
}

