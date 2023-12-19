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
    
    @MainActor
    private var  mainContainer: ModelContainer {
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
    private var debugingContainer: ModelContainer {
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
    private var compilingContainer: ModelContainer {
        #if DEBUG
            debugingContainer
        #else
            mainContainer
        #endif
    }
    
    //MARK: - Body
    
    var body: some Scene {
        VocabloScene(showWelcomeSheet: $isWelcomeSheetShowed)
            .modelContainer(compilingContainer)
        
        SettingsScene(isWelcomeSheetShowed: $isWelcomeSheetShowed)
            .defaultSize(width: 400, height: 500)
    }
}



extension View {
    func previewModelContainer() -> some View {
        self.modelContainer(for: [VocabularyList.self, Vocabulary.self, Tag.self], inMemory: true)

    }
}
