//
//  DuplicationPopoverButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 31.01.24.
//

import Foundation
import SwiftUI
import SwiftData

struct DuplicateVocabulariesPopoverButton: View {
    
    @Environment(\.modelContext) var modelContext
    let vocabulary: Vocabulary
    let list: VocabularyList?
    
    @State var isDuplicatesPopoverShown: Bool = false
    
    init(duplicatesOf vocabulary: Vocabulary, within list: VocabularyList?) {
        self.vocabulary = vocabulary
        self.list = list
    }
    
    var body: some View {
        Button {
            isDuplicatesPopoverShown.toggle()
        } label: {
            DuplicateWarningLabel()
        }
        .popover(isPresented: $isDuplicatesPopoverShown, content: {
            DuplicateVocabulariesPopover(duplicates: modelContext.fetchVocabularies(.duplicatesOf(vocabulary, withIn: list, sortBy: [.init(\.baseWord), .init(\.translationWord), .init(\.baseSentence), .init(\.translationSentence)])))
        })
    }
}
