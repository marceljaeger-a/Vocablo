//
//  NewListButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 01.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct AddNewDeckButton<LabelContent: View>: View {
    
    //MARK: - Dependencies
    
    var label: () -> LabelContent
    @Environment(\.modelContext) var modelContext
    
    //MARK: Initialiser
    
    init(
        label: @escaping () -> LabelContent = { Label("New deck", systemImage: "plus") }
    ) {
        self.label = label
    }
    
    //MARK: - Methods
    
    private func perform() {
        modelContext.insert(Deck.new)
        do {
            try modelContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Body
    
    var body: some View {
        Button {
            perform()
        } label: {
            label()
        }
    }
}
