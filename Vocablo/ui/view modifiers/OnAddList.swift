//
//  OnAddList.swift
//  Vocablo
//
//  Created by Marcel Jäger on 11.12.23.
//

import Foundation
import SwiftUI
import Combine
import SwiftData

extension View {
    func onAddList(action: @escaping (VocabularyList) -> Void ) -> some View {
        return self.onReceive(ModelContext.addListPublisher, perform: action)
    }
}
