//
//  VocabularyListItem.swift
//  Vocablo
//
//  Created by Marcel Jäger on 29.02.24.
//

import Foundation
import SwiftUI
import SwiftData

struct VocabularyListRow: View {
    @Bindable var list: VocabularyList
    
    var body: some View {
        let _ = Self._printChanges()
        Label {
            TextField("", text: $list.name)
        } icon: {
            Image(systemName: "book.pages")
        }
    }
}
