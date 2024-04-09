//
//  LeftWordsTextView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 25.03.24.
//

import Foundation
import SwiftUI

struct LeftWordsTextView: View {
    let wordsLeft: Int
    
    var body: some View {
        Text("\(wordsLeft) words left")
            .font(.callout)
            .fontDesign(.rounded)
            .foregroundStyle(.tertiary)
    }
}
