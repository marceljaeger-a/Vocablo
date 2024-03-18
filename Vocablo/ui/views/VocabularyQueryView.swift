//
//  VocabularyQueryView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 13.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct VocabularyQueryView<RowContent: View>: View {
    
    //MARK: - Dependencies
    
    @Query var vocabularies: Array<Vocabulary>
    let row: (Vocabulary) -> RowContent
    
    //MARK: - Initialiser
    
    init(fetchDescriptor: FetchDescriptor<Vocabulary> = .vocabularies(), rowContent: @escaping (Vocabulary) -> RowContent) {
        self._vocabularies = Query(fetchDescriptor)
        self.row = rowContent
    }
    
    init(_ query: Query<Vocabulary, Array<Vocabulary>>, rowContent: @escaping (Vocabulary) -> RowContent) {
        self._vocabularies = query
        self.row = rowContent
    }
    
    //MARK: - Body
    
    var body: some View {
        let _ = Self._printChanges()
        ForEach(vocabularies, id: \.self){ vocabulary in
            row(vocabulary)
        }
    }
}
