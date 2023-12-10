//
//  OnAddVocabulary.swift
//  Vocablo
//
//  Created by Marcel Jäger on 10.12.23.
//

import Foundation
import Combine
import SwiftUI
import SwiftData

extension View {
    func onAddVocabulary(to list: VocabularyList, action: @escaping (Vocabulary) -> Void ) -> some View {
        self.onReceive(list.addVocabularyPublisher, perform: action)
    }
}
