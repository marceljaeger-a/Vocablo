//
//  VocabularySortingPicker.swift
//  Vocablo
//
//  Created by Marcel Jäger on 13.03.24.
//

import Foundation
import SwiftUI

struct VocabularySortingPicker: View {
    @AppStorage(AppStorageKeys.vocabularySortingKey) var vocabularySortingKey: VocabularySortingKey = .createdDate
    @AppStorage(AppStorageKeys.vocabularySortingOrder) var vocabularySortingOrder: SortingOrder = .ascending
    
    var body: some View {
        Menu("Sort vocabularies") {
            Picker("By", selection: $vocabularySortingKey) {
                ForEach(VocabularySortingKey.allCases, id: \.rawValue) { sortingCase in
                    Text(sortingCase.label)
                        .tag(sortingCase)
                }
            }
            .pickerStyle(.inline)
            
            Divider()
            
            Picker("Order", selection: $vocabularySortingOrder) {
                ForEach(SortingOrder.allCases, id: \.rawValue) { sortingCase in
                    Text(sortingCase.label)
                        .tag(sortingCase)
                }
            }
            .pickerStyle(.inline)
        }
    }
}
