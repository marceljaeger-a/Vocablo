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
    
    //MARK: - Properties
    
    @State private var isWelcomeSheetShowed: Bool = true
    
    //MARK: - Body
    
    var body: some Scene {
        VocabloScene(isWelcomeSheetShowed: $isWelcomeSheetShowed)
            .modelContainer(.current)
        
        SettingsScene(isWelcomeSheetShowed: $isWelcomeSheetShowed)
            .defaultSize(width: 400, height: 500)
    }
}

