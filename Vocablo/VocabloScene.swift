//
//  VocabloScene.swift
//  Vocablo
//
//  Created by Marcel Jäger on 09.12.23.
//

import Foundation
import SwiftUI
import SwiftData
import Combine

struct VocabloScene: Scene {
    @Environment(\.modelContext) var context: ModelContext
    
    @Binding var showWelcomeSheet: Bool
    
    @State var selectedListIDs: Set<PersistentIdentifier> = []
    @State var selectedVocabularyIDs: Set<PersistentIdentifier> = []
    @State var showLearningSheet: Bool = false
    
    @State var showContextSaveErrorAlert: Bool = false
    
    var body: some Scene {
        WindowGroup {
            ContentView(selectedListIDs: $selectedListIDs, selectedVocabularyIDs: $selectedVocabularyIDs, showLearningSheet: $showLearningSheet)
                .alert("Save failed!", isPresented: $showContextSaveErrorAlert) {
                    Button {
                        showContextSaveErrorAlert = false
                    } label: {
                        Text("Ok")
                    }
                }
                .sheet(isPresented: $showWelcomeSheet) {
                    VStack(spacing: 50){
                        VStack(spacing: 15){
                            Image(.appIcon)
                                .resizable()
                                .frame(width: 64, height: 64)
                            
                            VStack(spacing: 10){
                                Text("Welcome to Vocablo")
                                    .font(.largeTitle)
                                    .fontDesign(.default)
                                
                                Text("Version 1.0")
                                    .font(.title3)
                                    .fontDesign(.default)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        Grid(alignment: .leading, verticalSpacing: 25){
                            GridRow {
                                Color.accentColor.frame(width: 64, height: 64).mask {
                                    Image(systemName: "list.bullet.rectangle.portrait")
                                        .symbolVariant(.fill)
                                        .font(.largeTitle)
                                }
//                                Image(systemName: "list.bullet.rectangle.portrait")
//                                    .symbolVariant(.fill)
//                                    .font(.largeTitle)
//                                    .foregroundStyle(.accent)
                                
                                VStack(alignment: .leading){
                                    Text("Add lists with vocabularies")
                                        .font(.title3)
                                        .bold()
                                    
                                    Text("Create lists and add vocabularies. Configure the vocabularies.")
                                        .foregroundStyle(.secondary)
                                }
                            }

                            GridRow{
                                Color.accentColor.frame(width: 64, height: 64).mask {
                                    Image(systemName: "graduationcap")
                                        .symbolVariant(.fill)
                                        .font(.largeTitle)
                                }
//                                Image(systemName: "graduationcap")
//                                    .symbolVariant(.fill)
//                                    .font(.largeTitle)
//                                    .foregroundStyle(.accent)
                                
                                VStack(alignment: .leading){
                                    Text("Learn vocabularies")
                                        .font(.title3)
                                        .bold()
                                    
                                    Text("Learn with spaced repetition algorythm.")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        
                        Button {
                            showWelcomeSheet = false
                        } label: {
                            Text("Continue")
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.extraLarge)
                    }
                    .padding(25)
                }
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("Add list") {
                    context.addList("New list")
                }
                .keyboardShortcut(KeyEquivalent("n"), modifiers: .command.union(.option))
                
                Button("Add vocabulary") {
                    guard let firstSelectedList: VocabularyList =  context.fetch(ids: selectedListIDs).first else { return }
                    firstSelectedList.addNewVocabulary()
                }
                .keyboardShortcut(KeyEquivalent("n"), modifiers: .command)
                .disabled(selectedListIDs.isEmpty)
            }
            
            CommandGroup(after: .pasteboard) {
                Divider()
                
                CommandWordGroupPicker(vocabularies: context.fetch(ids: selectedVocabularyIDs))
                    .disabled(selectedVocabularyIDs.isEmpty)
                
                Divider()
                
                if let firstList: VocabularyList = context.fetch(ids: selectedListIDs).first{
                    @Bindable var bindedList = firstList
                    Picker("List sort by", selection: $bindedList.sorting) {
                        VocabularyList.VocabularySorting.pickerContent
                    }
                    .disabled(selectedListIDs.count != 1)
                }else {
                    Menu("List sort by") {
                        
                    }
                    .disabled(selectedListIDs.count != 1)
                }
            }
            
            CommandMenu("Learning") {
                Button("Learn") {
                    showLearningSheet = true
                }
                .disabled(selectedListIDs.count != 1)
                
                Divider()
                
                Button("To learn"){
                    context.toLearn(for: context.fetch(ids: selectedVocabularyIDs))
                }
                .keyboardShortcut(KeyEquivalent("l"), modifiers: .command)
                .disabled(selectedVocabularyIDs.isEmpty)
                
                Button("Not to learn"){
                    context.notToLearn(for: context.fetch(ids: selectedVocabularyIDs))
                }
                .keyboardShortcut(KeyEquivalent("l"), modifiers: .command.union(.shift))
                .disabled(selectedVocabularyIDs.isEmpty)
                
                Divider()
                
                Button("Reset lists") {
                    context.resetList(context.fetch(ids: selectedListIDs))
                }
                .disabled(selectedListIDs.isEmpty)
                
                Button("Reset vocabularies") {
                    context.resetVocabularies(context.fetch(ids: selectedVocabularyIDs))
                }
                .disabled(selectedVocabularyIDs.isEmpty)
            }
        }
    }
}
