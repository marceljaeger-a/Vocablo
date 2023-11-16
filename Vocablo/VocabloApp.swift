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
        DocumentGroup(editing: [VocabularyList.self, Tag.self], contentType: .vocablo) {
            ContentView()
        }
    }
}
