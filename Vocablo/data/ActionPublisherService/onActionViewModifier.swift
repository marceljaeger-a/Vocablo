//
//  onActionViewModifier.swift
//  Vocablo
//
//  Created by Marcel Jäger on 23.01.24.
//

import Foundation
import SwiftUI

struct OnActionModifier<A: ActionPublisher>: ViewModifier {
    @Environment(\.actionReactingService) var service
     
    ///The ``ActionPublisher`` that the view should subscribe.
    var action: KeyPath<ActionReactingService, A>
    
    ///The code that should be performed when the ``ActionPublisher`` sends a value.
    var perform: (A.SubjectResult) -> Void
    
    func body(content: Content) -> some View {
        content.onReceive(service[keyPath: action].subject, perform: perform)
    }
}
