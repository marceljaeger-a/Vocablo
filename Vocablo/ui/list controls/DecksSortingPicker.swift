//
//  ListSortingPicker.swift
//  Vocablo
//
//  Created by Marcel Jäger on 12.03.24.
//

import Foundation
import SwiftUI

struct DecksSortingPicker: View {
    @AppStorage(AppStorageKeys.decksSortingKey) var decksSortingKey: DecksSortingKey = .createdDate
    @AppStorage(AppStorageKeys.decksSortingOrder) var decksSortingOrder: SortingOrder = .ascending
    
    var body: some View {
        Menu("Sort sidebar") {
            Picker("By", selection: $decksSortingKey) {
                ForEach(DecksSortingKey.allCases, id: \.rawValue) { sortingCase in
                    Text(sortingCase.label)
                        .tag(sortingCase)
                }
            }
            .pickerStyle(.inline)
            
            Divider()
            
            Picker("Order", selection: $decksSortingOrder) {
                ForEach(SortingOrder.allCases, id: \.rawValue) { sortingCase in
                    Text(sortingCase.label)
                        .tag(sortingCase)
                }
            }
            .pickerStyle(.inline)
        }
    }
}
