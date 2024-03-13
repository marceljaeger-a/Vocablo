//
//  ListSortingPicker.swift
//  Vocablo
//
//  Created by Marcel Jäger on 12.03.24.
//

import Foundation
import SwiftUI

struct ListSortingPicker: View {
    @AppStorage(AppStorageKeys.listSortingKey) var listSortingKey: ListSortingKey = .createdDate
    @AppStorage(AppStorageKeys.listSortingOrder) var listSortingOrder: SortingOrder = .ascending
    
    var body: some View {
        Menu("Sort sidebar") {
            Picker("By", selection: $listSortingKey) {
                ForEach(ListSortingKey.allCases, id: \.rawValue) { sortingCase in
                    Text(sortingCase.label)
                        .tag(sortingCase)
                }
            }
            .pickerStyle(.inline)
            
            Divider()
            
            Picker("Order", selection: $listSortingOrder) {
                ForEach(SortingOrder.allCases, id: \.rawValue) { sortingCase in
                    Text(sortingCase.label)
                        .tag(sortingCase)
                }
            }
            .pickerStyle(.inline)
        }
    }
}
