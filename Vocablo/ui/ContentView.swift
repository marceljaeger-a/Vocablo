//
//  ContentView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 23.10.23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        DocumentNavigationView()
    }
}

#Preview {
    ContentView()
        .previewModelContainer()
}

extension View {
    func previewModelContainer() -> some View {
        self.modelContainer(for: [VocabularyList.self, Vocabulary.self, Tag.self], inMemory: true)
    }
}
