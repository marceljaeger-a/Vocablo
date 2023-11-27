//
//  TagMultiPicker.swift
//  Vocablo
//
//  Created by Marcel Jäger on 26.11.23.
//

import Foundation
import SwiftUI

struct TagMultiPicker: View {
    @Bindable var vocabulary: Vocabulary
    let tags: Array<Tag>
    
    var body: some View {
        Menu {
            ForEach(tags) { tag in
                Button {
                    selectTag(tag)
                } label: {
                    HStack {
                        Image(systemName: "tag")
                            .symbolVariant(vocabulary.hasTag(tag) ? .fill : .none)
                        
                        Text(tag.name)
                    }
                }
            }
        } label: {
            let tagListString = { () -> String in
                var tagsString = ""
                for tag in vocabulary.tags {
                    if tagsString.isEmpty {
                        tagsString += tag.name
                    }else {
                        tagsString += ", \(tag.name)"
                    }
                }
                return tagsString
            }()
            
            Text(tagListString)
        }
        .menuStyle(.borderlessButton)
    }
    
    private func selectTag(_ tag: Tag) {
        vocabulary.toggleTag(tag)
    }
}
