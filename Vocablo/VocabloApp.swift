//
//  VocabloApp.swift
//  Vocablo
//
//  Created by Marcel Jäger on 23.10.23.
//

import SwiftUI
import SwiftData

@main
struct VocabloApp: App {
    
    //MARK: - Body
    
    var body: some Scene {
        VocabloScene()
            .modelContainer(.current)
        
        SettingsScene()
            .defaultSize(width: 400, height: 500)
    }
}

