//
//  DeletingConfirmationDialog.swift
//  Vocablo
//
//  Created by Marcel Jäger on 29.11.23.
//

import Foundation
import SwiftUI

extension View {
    func deletingConfirmationDialog(isPresented: Binding<Bool>, title: String, cancelAction: @escaping () -> Void, deletingAction: @escaping () -> Void) -> some View {
        self.confirmationDialog(title, isPresented: isPresented) {
            Button(role: .cancel){
               cancelAction()
            } label: {
                Text("Cancel")
            }
            
            Button(role: .destructive){
                deletingAction()
            } label: {
                Text("Delete")
            }
        }
    }
}
