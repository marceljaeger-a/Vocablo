//
//  LearningView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 28.10.23.
//

import SwiftUI


struct LearningView: View {
    let list: VocabularyList
    
    var body: some View {
        if let firstLearningVocabulary = list.learningVocabulariesToday.first {
            LearnableView(learnable: firstLearningVocabulary.0, reverse: firstLearningVocabulary.isReverse)
                .overlay {
                    var showNewVocabularyLabel: Bool {
                        switch firstLearningVocabulary.isReverse {
                        case true:
                            return firstLearningVocabulary.0.translatedLearningState.isNewly
                        case false:
                            return firstLearningVocabulary.0.learningState.isNewly
                        }
                    }
                    
                    VStack {
                        NewVocabularyLabel()
                            .opacity(showNewVocabularyLabel ? 1.0 : 0.0)
                    
                        Spacer()
                        
                        HStack {
                            Spacer()
                            RemainingVocabulariesCountLabel(count: list.learningVocabulariesTodayCount)
                        }
                    }
                    .padding()
                }
        }else {
            ContentUnavailableView("No vocabulary to learn today!", systemImage: "calendar.badge.checkmark")
        }
    }
    
    private struct NewVocabularyLabel: View {
        var body: some View {
            Text("NEW")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.blue.gradient)
                .fontDesign(.rounded)
                .shadow(color: .blue, radius: 8)
                .padding()
        }
    }
    
    private struct RemainingVocabulariesCountLabel: View {
        let count: Int
        var body: some View {
            Text("\(count)")
                .font(.title3)
                .fontDesign(.monospaced)
                .foregroundStyle(.secondary)
        }
    }
}

fileprivate struct LearnableView: View {
    @State var showTranslation: Bool = false
    
    var learnable: Learnable
    let reverse: Bool
    
    var learnableContext: (word: String, sentence: String, reverseWord: String, reverseSentence: String) {
        if reverse {
            return (learnable.translatedWord, learnable.translatedSentence, learnable.word, learnable.sentence)
        }else {
            return (learnable.word, learnable.sentence, learnable.translatedWord, learnable.translatedSentence)
        }
    }
    var learnableLearningState: Binding<LearningState> {
        if reverse {
            return Binding {
                learnable.translatedLearningState
            } set: { newState in
                learnable.translatedLearningState = newState
            }
        }else {
            return Binding {
                learnable.learningState
            } set: { newState in
                learnable.learningState = newState
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            LearnableSideView(word: learnableContext.word, sentence: learnableContext.sentence)
            
            LearnableSideView(word: learnableContext.reverseWord, sentence: learnableContext.reverseSentence, showSide: $showTranslation)
        }
        .padding()
        .frame(width: 1000, height: 800)
        .overlay {
            LearnableAnswersView(
                learningState: learnableLearningState,
                showTranslation: $showTranslation
            )
        }
    }
}

fileprivate struct LearnableSideView: View {
    let word: String
    let sentence: String
    @Binding var showSide: Bool
    
    init(word: String, sentence: String, showSide: Binding<Bool> = .constant(true)) {
        self.word = word
        self.sentence = sentence
        self._showSide = showSide
    }
    
    var body: some View {
        VStack(spacing: 10){
            Text(word)
                .opacity(showSide ? 1.0 : 0)
            Divider()
                .opacity(showSide ? 1.0 : 0)
            Text(sentence)
                .opacity(showSide ? 1.0 : 0)
        }
        .font(.headline)
        .padding()
        .frame(minHeight: 250)
        .background(in: .rect(cornerRadius: 15))
        .backgroundStyle(.thickMaterial)
        .overlay {
            if !showSide {
                Button {
                    withAnimation {
                        showSide.toggle()
                    }
                }label: {
                    Image(systemName: "questionmark")
                        .imageScale(.large)
                        .font(.title)
                        .bold()
                }
                .buttonStyle(.borderless)
            }
        }
    }
}

fileprivate struct LearnableAnswersView: View {
    @Binding var learningState: LearningState
    @Binding var showTranslation: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack(spacing: 20){
                Button {
                    learningState.levelDown()
                    showTranslation = false
                } label: {
                    Label(learningState.downLevel.repeatIntervalLabel, systemImage: "hand.thumbsdown.fill")
                        .foregroundStyle(.red)
                        .frame(minWidth: 75, minHeight: 25)
                }
                .controlSize(.extraLarge)
                
                Button {
                    learningState.levelUp()
                    showTranslation = false
                } label: {
                    Label(learningState.nextLevel.repeatIntervalLabel, systemImage: "hand.thumbsup.fill")
                        .foregroundStyle(.green)
                        .frame(minWidth: 75, minHeight: 25)
                }
                .controlSize(.extraLarge)
            }
        }
        .padding()
    }
}

#Preview {
    LearningView(list: .init("Preview"))
}
