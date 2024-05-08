//
//  WindowGroupScene.swift
//  Vocablo
//
//  Created by Marcel Jäger on 04.03.24.
//

import Foundation
import SwiftUI

struct WindowGroupScene: Scene {
    @Environment(\.modelContext) var modelContext
    
    var body: some Scene {
        WindowGroup {
            ContentNavigationView()
        }
        .defaultSize(width: 1280, height: 720)
        .commands {
            DeckCommands(modelContext: modelContext)
            VocabularyCommands(modelContext: modelContext)
            LearningCommands(modelContext: modelContext)
        }
    }
}
