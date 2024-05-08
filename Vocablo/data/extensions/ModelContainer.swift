//
//  ModelContainer.swift
//  Vocablo
//
//  Created by Marcel Jäger on 05.01.24.
//

import Foundation
import SwiftData
import SwiftUI

extension ModelContainer {
    
    @MainActor
    static var main: ModelContainer {
        var container: ModelContainer
        do {
            let schema = Schema([Deck.self, Vocabulary.self])
            let configuration = ModelConfiguration("vocablo_datastorage2_main", schema: schema)
            container = try ModelContainer(for: schema, configurations: [configuration])

            container.mainContext.autosaveEnabled = true
        } catch {
            fatalError()
        }
        return container
    }
    
    @MainActor
    static var debug: ModelContainer {
        var container: ModelContainer
        do {
            let schema = Schema([Deck.self, Vocabulary.self])
            let configuration = ModelConfiguration("vocablo_datastorage2_debug", schema: schema)
            container = try ModelContainer(for: schema, configurations: [configuration])
            
            container.mainContext.autosaveEnabled = true
        } catch {
            fatalError()
        }
        return container
    }
    
    ///Returns either the debug or main ModelContainer.
    ///- debug: If you run the app in debugging or developing.
    ///- main: If you run the app as compiled.
    @MainActor
    static var current: ModelContainer {
        #if DEBUG
            debug
        #else
            main
        #endif
    }
}



extension View {
    func previewModelContainer() -> some View {
        self.modelContainer(for: [Deck.self, Vocabulary.self], inMemory: true)

    }
}

