//
//  LinkUndoManager.swift
//  Vocablo
//
//  Created by Marcel Jäger on 13.12.23.
//

import Foundation
import SwiftUI
import SwiftData

extension View {
    func linkContextUndoManager(context: ModelContext, with environmentUndoManager: UndoManager?) -> some View {
        self.onAppear { context.undoManager = environmentUndoManager }
    }
}
