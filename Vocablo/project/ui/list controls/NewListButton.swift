//
//  NewListButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 01.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct NewListButton: View {
    
    //MARK: - Dependencies
    
    @Environment(\.modelContext) var modelContext
    
    //MARK: - Methods
    
    
    
    //MARK: - Body
    
    var body: some View {
        Button {
            modelContext.insert(VocabularyList.newList)
            do {
                try modelContext.save()
            } catch {
                print(error.localizedDescription)
            }
        } label: {
            Label("New list", systemImage: "plus")
        }
    }
}
