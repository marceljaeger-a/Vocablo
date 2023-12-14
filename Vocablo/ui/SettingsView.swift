//
//  SettingsView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 11.12.23.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @Binding var showWelcomeSheet: Bool
    
    
    var body: some View {
        Form {
            Toggle("Show feature info sheet", isOn: $showWelcomeSheet)
        }
        .formStyle(.grouped)
        .padding()
    }
}
