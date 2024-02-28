//
//  DuplicationPopover.swift
//  Vocablo
//
//  Created by Marcel Jäger on 30.01.24.
//

import Foundation
import SwiftUI

struct DuplicateVocabulariesPopover: View {
    
    let duplicates: Array<Vocabulary>
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(duplicates) { duplicate in
                    DuplicateItem(duplicate: duplicate)
                }
            }
            .padding(10)
        }
        .frame(maxHeight: 230)
    }
}

extension DuplicateVocabulariesPopover {
    struct DuplicateItem: View {
        
        @Bindable var duplicate: Vocabulary
        
        @Environment(\.sheetContext) var sheetContext
        @Environment(\.modelContext) var modelContext
        @Environment(\.selectionContext) var selectionContext
        
        var body: some View {
            VStack {
                HStack(alignment: .center){
                    Text(duplicate.baseWord)
                        
                    Spacer()
                    
                    Divider()
                        .foregroundStyle(.ultraThickMaterial)
                    
                    Text(duplicate.translationWord)
                    
                    Spacer()
                }
                
                if let listName = duplicate.list?.name {
                    HStack {
                        Text(listName)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                    }
                    .padding(.vertical, 3)
                }
                
                HStack{
                    Button {
                        sheetContext.editingVocabulary = duplicate
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive){
                        _ = selectionContext.unselectVocabularies([duplicate.id])
                        modelContext.delete(models: [duplicate])
                    } label: {
                        Label("Delete", systemImage: "trash")
                            .foregroundStyle(.red)
                    }
                    
                    Spacer()
                }
                .controlSize(.small)
                .padding(.top, 10)
            }
            .frame(minWidth: 150)
            .padding(10)
            .background(.regularMaterial.shadow(.drop(radius: 1)), in: .rect(cornerRadius: 10))
        }
    }
}

#Preview {
    Text("Preview")
        .popover(isPresented: .constant(true), content: {
            DuplicateVocabulariesPopover(duplicates: [])
        })
}
