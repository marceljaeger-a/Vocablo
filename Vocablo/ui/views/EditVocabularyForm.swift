//
//  EditVocabularyForm.swift
//  Vocablo
//
//  Created by Marcel Jäger on 02.05.24.
//

import Foundation
import SwiftUI

struct VocabularyPopoverView: View {
    @Bindable var vocabulary: Vocabulary
    
    @State var areMoreConfigurationExpanded: Bool = false
    
    var body: some View {
        Form {
            TextField("", text: $vocabulary.baseWord, prompt: Text("Word, ..."))
            TextField("", text: $vocabulary.translationWord, prompt: Text("Word, ..."))
            
            Divider()
            
            TextField("", text: $vocabulary.baseSentence, prompt: Text("Sample sentence, explenation, ..."), axis: .vertical)
                .lineLimit(1...5)
                .fixedSize(horizontal: false, vertical: true)
        
            TextField("", text: $vocabulary.translationSentence, prompt: Text("Sample sentence, explenation, ..."), axis: .vertical)
                .lineLimit(1...5)
                .fixedSize(horizontal: false, vertical: true)
            
            Divider()
            
            Toggle("To learn", isOn: $vocabulary.isToLearn)
            
            Divider()
            
            Section(isExpanded: $areMoreConfigurationExpanded) {
                HStack {
                    Text("Translation to Word")
                        .foregroundStyle(.secondary)
                }
                LearningLevelPicker(title: "Level", level: $vocabulary.levelOfTranslation)
                HStack {
                    Text("Next repetition in ")
                    if vocabulary.nextSessionOfBase > Date.now {
                        Text(vocabulary.nextSessionOfBase, style: .timer)
                    }else {
                        Text("0:00")
                    }
                }
                
                Divider()
                
                HStack {
                    #warning("Implement languages to list.")
                    Text("Word to Translation")
                        .foregroundStyle(.secondary)
                }
                LearningLevelPicker(title: "Level", level: $vocabulary.levelOfBase)
                HStack {
                    Text("Next repetition in ")
                    if vocabulary.nextSessionOfTranslation > Date.now {
                        Text(vocabulary.nextSessionOfTranslation, style: .timer)
                    }else {
                        Text("0:00")
                    }
                }
            } header: {
                HStack {
                    Spacer()
                    Button {
                        areMoreConfigurationExpanded.toggle()
                    } label: {
                        if areMoreConfigurationExpanded {
                            Text("Hide more configuration")
                        }else {
                            Text("Show more configuration")
                        }
                    }
                    .buttonStyle(.borderless)
                    Spacer()
                }
            }
        }
        .padding()
        .textFieldStyle(.plain)
        .frame(minWidth: 400, maxWidth: 400)
    }
}
