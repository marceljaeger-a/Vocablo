//
//  onAction.swift
//  Vocablo
//
//  Created by Marcel Jäger on 23.01.24.
//

import Foundation
import SwiftUI

extension View {
    func onAction<A: ActionPublisher>(_ action: KeyPath<ActionReactingService, A>, perform: @escaping (A.SubjectResult) -> Void ) -> some View {
        self.modifier(OnActionModifier(action: action, perform: perform))
    }
}
