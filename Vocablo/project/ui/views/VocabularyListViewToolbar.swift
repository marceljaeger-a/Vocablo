//
//  VocabularyListViewToolbar.swift
//  Vocablo
//
//  Created by Marcel Jäger on 06.03.24.
//

import Foundation
import SwiftData
import SwiftUI

struct VocabularyListViewToolbar: ToolbarContent {
    let selectedList: VocabularyList?
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigation) {
            Button {
                
            } label: {
                Image(.wordlistPlay)
            }
        }
        
        ToolbarItem(placement: .primaryAction) {
            AddNewVocabularyButton(into: selectedList)
        }
    }
}
