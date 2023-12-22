//
//  SettingsScene.swift
//  Vocablo
//
//  Created by Marcel Jäger on 15.12.23.
//

import Foundation
import SwiftUI

struct SettingsScene: Scene {
    @Binding var isWelcomeSheetShowed: Bool
    
    var body: some Scene {
        Settings {
            Form {
                Toggle("Show welcome sheet", isOn: $isWelcomeSheetShowed)
            }
            .formStyle(.grouped)
            .padding()
        }
    }
}

