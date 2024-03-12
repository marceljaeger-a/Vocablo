//
//  NewVocabularyButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 01.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct AddNewVocabularyButton<LabelContent: View>: View {
    
    //MARK: - Dependencies
    
    let list: VocabularyList?
    var label: () -> LabelContent
    
    @Environment(\.modelContext) var modelContext
    
    //MARK: - Initialiser
    
    init(
        into list: VocabularyList?,
        label: @escaping () -> LabelContent = { Label("New vocabulary", systemImage: "plus") }
    ) {
        self.list = list
        self.label = label
    }
    
    //MARK: - Methods
    
    private func perform() {
        #warning("The new vocabulary needs to be focused!")
        let newVocabulary = Vocabulary.newVocabulary
        
        if let list {
            list.append(vocabulary: newVocabulary)
            do {
                try modelContext.save()
            }catch {
                print(error.localizedDescription)
            }
        }else {
            modelContext.insert(newVocabulary)
            do {
                try modelContext.save()
            }catch {
                print(error.localizedDescription)
            }
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
