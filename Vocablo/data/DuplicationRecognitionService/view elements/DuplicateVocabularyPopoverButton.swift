//
//  DuplicationPopoverButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 31.01.24.
//

import Foundation
import SwiftUI

struct DuplicateVocabulariesPopoverButton: View {
    
    let duplicates: Array<Vocabulary>
    let duplicateRecogniser: DuplicateRecognitionService = .init()
    
    @State var isDuplicatesPopoverShown: Bool = false
    
    init(duplicatesOf vocabulary: Vocabulary, within otherVocabularies: Array<Vocabulary>) {
        self.duplicates = duplicateRecogniser.duplicates(of: vocabulary, within: otherVocabularies)
    }
    
    var body: some View {
        Button {
            isDuplicatesPopoverShown.toggle()
        } label: {
            DuplicateWarningLabel()
        }
        .popover(isPresented: $isDuplicatesPopoverShown, content: {
            DuplicateVocabulariesPopover(duplicates: duplicates)
        })
    }
}
