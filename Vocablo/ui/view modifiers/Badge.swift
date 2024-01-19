//
//  Badge.swift
//  Vocablo
//
//  Created by Marcel Jäger on 29.11.23.
//

import Foundation
import SwiftUI

extension View {
    func badge(_ value: String, prominece: BadgeProminence) -> some View {
        self.badge(value).badgeProminence(prominece)
    }
    
    func badge(_ value: Int, prominece: BadgeProminence) -> some View {
        self.badge(value).badgeProminence(prominece)
    }
}
