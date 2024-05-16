//
//  EditDeckSheetModifier.swift
//  Vocablo
//
//  Created by Marcel Jäger on 14.05.24.
//

import Foundation
import SwiftUI

struct DeckDetailSheetModifier: ViewModifier {
    @Environment(ModalPresentationModel.self) var modalPresentationModel
    
    func body(content: Content) -> some View {
        content.sheet(isPresented: modalPresentationModel.bindable.isDeckDetailSheetShown) {
            DeckDetailForm(editingDeck: modalPresentationModel.editingDeck)
        }
    }
}

