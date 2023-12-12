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
    
    @State var showWelcomeSheet: Bool = true
    
    @MainActor
    var  mainContainer: ModelContainer {
        var container: ModelContainer
        do {
            container = try ModelContainer(for: VocabularyList.self, Tag.self, configurations: ModelConfiguration("vocablo_datastorage_main", isStoredInMemoryOnly: false))
            container.mainContext.undoManager = UndoManager()
            container.mainContext.autosaveEnabled = true
        } catch {
            fatalError()
        }
        return container
    }
    
    var developContainer: ModelContainer {
        var container: ModelContainer
        do {
            container = try ModelContainer(for: VocabularyList.self, Tag.self, configurations: .init("vocablo_datastorage_develop", isStoredInMemoryOnly: false))
        } catch {
            fatalError()
        }
        return container
    }
    
    var body: some Scene {
        VocabloScene(showWelcomeSheet: $showWelcomeSheet)
        #if DEBUG
        .modelContainer(developContainer)
        #else
        .modelContainer(mainContainer)
        #endif
        
        Settings {
            SettingsView(showWelcomeSheet: $showWelcomeSheet)
        }
        .defaultSize(width: 400, height: 500)
    }
}
