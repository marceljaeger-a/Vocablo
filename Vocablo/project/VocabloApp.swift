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
        WindowGroupScene()
            .modelContainer(ModelContainer.current)
    }
}

