//
//  SidebarMenuCommands.swift
//  Vocablo
//
//  Created by Marcel Jäger on 29.02.24.
//

import Foundation
import SwiftUI
import SwiftData

struct LearningCommands: Commands {
    let modelContext: ModelContext
    
    var body: some Commands {
        CommandMenu("Learning") {
            Text("Learn vocabuaries of list")
            
            Text("Learn selected vocabularies")
        }
    }
}
