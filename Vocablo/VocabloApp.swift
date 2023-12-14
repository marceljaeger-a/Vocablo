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
            let schema = Schema([VocabularyList.self, Tag.self])
            let configuration = ModelConfiguration("vocablo_datastorage_main", schema: schema)
            container = try ModelContainer(for: schema, configurations: [configuration])
            
            container.mainContext.autosaveEnabled = true
        } catch {
            fatalError()
        }
        return container
    }
    
    @MainActor
    var developContainer: ModelContainer {
        var container: ModelContainer
        do {
            let schema = Schema([VocabularyList.self, Tag.self])
            let configuration = ModelConfiguration("vocablo_datastorage_develop", schema: schema)
            container = try ModelContainer(for: schema, configurations: [configuration])
            
            container.mainContext.autosaveEnabled = true
            container.mainContext.undoManager = UndoManager()
        } catch {
            fatalError()
        }
        return container
    }
    
    @MainActor
    var container: ModelContainer {
        #if DEBUG
            developContainer
        #else
            mainContainer
        #endif
    }
    
    var body: some Scene {
        VocabloScene(showWelcomeSheet: $showWelcomeSheet)
            .modelContainer(container)
        
        Settings {
            SettingsView(showWelcomeSheet: $showWelcomeSheet)
        }
        .defaultSize(width: 400, height: 500)
    }
}
