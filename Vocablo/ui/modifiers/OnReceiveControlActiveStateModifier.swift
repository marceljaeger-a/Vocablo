//
//  OnReceiveControlActiveState.swift
//  Vocablo
//
//  Created by Marcel Jäger on 19.03.24.
//

import Foundation
import SwiftUI
import Combine

struct OnReceiveControlActiveStateModifier<P: Publisher>: ViewModifier where P.Failure == Never {
    
    let publisher: P
    let controlActiveState: ControlActiveState
    let perform: (P.Output) -> Void
    
    @Environment(\.controlActiveState) var environmentControlActiveState
    
    func body(content: Content) -> some View {
        content.onReceive(publisher) { output in
            if environmentControlActiveState == controlActiveState {
                perform(output)
            }
        }
    }
}

extension View {
    func onReceive<P: Publisher>(_ publisher: P, performIfControlActiveStateIs controlActiveState: ControlActiveState, perform: @escaping (P.Output) -> Void) -> some View where P.Failure == Never  {
        self.modifier(OnReceiveControlActiveStateModifier(publisher: publisher, controlActiveState: controlActiveState, perform: perform))
    }
}
