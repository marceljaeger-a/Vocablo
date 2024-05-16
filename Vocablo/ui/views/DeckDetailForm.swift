//
//  DeckDetailForm.swift
//  Vocablo
//
//  Created by Marcel Jäger on 14.05.24.
//

import Foundation
import SwiftUI
import SwiftData

struct DeckDetailForm: View {
    
    //MARK: - Dependencies
    
    var editingDeck: Deck? = nil
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismissAction
    
    @State var name: String = ""
    @State var languageOfBase: String = ""
    @State var languageOfTranslation: String = ""
    
    var sheetTitle: String {
        return if editingDeck == nil {
            "New deck"
        }else {
            "Edit deck"
        }
    }
    
    //MARK: - Methods
    
    private func setUpPropertiesOfView() {
        if let editingDeck {
            self.name = editingDeck.name
            self.languageOfBase = editingDeck.languageOfBase
            self.languageOfTranslation = editingDeck.languageOfTranslation
        }
    }
    
    private func saveDeckAndDismiss() {
        if let editingDeck {
            editingDeck.name = self.name
            editingDeck.languageOfBase = self.languageOfBase
            editingDeck.languageOfTranslation = self.languageOfTranslation
        }else {
            let newDeck = Deck(name: self.name, languageOfBase: self.languageOfBase, languageOfTranslation: self.languageOfTranslation)
            modelContext.insert(newDeck)
        }
        
        dismissAction()
    }
    
    private func cancelAndDismiss() {
        dismissAction()
    }
    
    //MARK: - Body
    
    var body: some View {
        VStack {
            Text(sheetTitle)
                .font(.title)
                .fontDesign(.rounded)
                .padding()
            
            Form {
                TextField("", text: $name, prompt: Text("Name"))
                TextField("", text: $languageOfBase, prompt: Text("Language of first content"))
                TextField("", text: $languageOfTranslation, prompt: Text("Language of second content"))
            }
            .formStyle(.grouped)
            .scrollDisabled(true)
            .textFieldStyle(.plain)
            .onAppear {
                setUpPropertiesOfView()
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        cancelAndDismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                
                ToolbarItem(placement: .confirmationAction){
                    Button {
                        saveDeckAndDismiss()
                    } label: {
                        Text("Done")
                    }
                }
            }
            .frame(minWidth: 200, maxWidth: 400)
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}
