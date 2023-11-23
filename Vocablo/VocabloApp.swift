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
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [VocabularyList.self, Tag.self], inMemory: true, isAutosaveEnabled: true, isUndoEnabled: true) { result in
            
        }
//        DocumentGroup(editing: [VocabularyList.self, Tag.self], contentType: .vocablo) {
//            ContentView()
//        } prepareDocument: { context in
//           
//        }
    }
}
