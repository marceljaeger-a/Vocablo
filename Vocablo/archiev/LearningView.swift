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
                    VStack {
                        Spacer()
                        
                        HStack {
                            Spacer()
                            RemainingVocabulariesCountLabel(count: list.learningVocabulariesTodayCount)
                        }
                    }
                    .padding()
                }
        }else {
#warning("The reason of the console print `=== AttributeGraph: cycle detected through attribute 662336 ===` is the ContentUnavailableView! I do not why this is so, because when I put this View into the sheet modifier alone, this message is also printed in the console. Maybe it is a SwiftUI Bug! But this is only in a sheet. For example in a popover it is not. I test it on an iOS Project and it did not print. On a another macOS App with only a button it did print also!")
            ContentUnavailableView("No vocabulary to learn today!", systemImage: "calendar.badge.checkmark")
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

fileprivate struct NewVocabularyLabel: View {
    var body: some View {
        Text("NEW")
            .font(.title2)
            .bold()
            .foregroundStyle(.blue.gradient)
            .fontDesign(.rounded)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(.blue.opacity(0.4), in: .rect(cornerRadius: 8))
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
    var learnableLearningState: LearningState {
        get {
            if reverse {
                return learnable.translatedLearningState
            }else {
                return learnable.learningState
            }
        }
        set {
            if reverse {
                learnable.translatedLearningState = newValue
            }else {
                learnable.learningState = newValue
            }
        }
    }
    
    var bindedLearnableLearningState: Binding<LearningState> {
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
            
            Divider()
            
            LearnableSideView(word: learnableContext.reverseWord, sentence: learnableContext.reverseSentence, showSide: $showTranslation)
        }
        .padding()
        .frame(width: 1000, height: 800)
        .overlay {
            LearnableAnswersView(
                learningState: bindedLearnableLearningState,
                showTranslation: $showTranslation
            )
        }
        .overlay {
            VStack {
                NewVocabularyLabel()
                    .opacity(learnableLearningState.isNewly ? 1.0 : 0.0)
                Spacer()
            }
            .padding(10)
        }
    }
}

fileprivate struct LearnableSideView: View {
    let word: String
    let sentence: String
    @Binding var isSideShowing: Bool
    
    init(word: String, sentence: String, showSide: Binding<Bool> = .constant(true)) {
        self.word = word
        self.sentence = sentence
        self._isSideShowing = showSide
    }
    
    var viewOpacity: Double {
        isSideShowing ? 1.0 : 0
    }
    
    var body: some View {
        VStack(spacing: 10){
            Text(word)
                .font(.title2)
                .bold()
                .opacity(viewOpacity)
            Text(sentence)
                .font(.headline)
                .foregroundStyle(.secondary)
                .opacity(viewOpacity)
        }
        .padding()
        .frame(minHeight: 250)
        .overlay {
            if !isSideShowing {
                Button {
                    onShowSide()
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
    
    private func onShowSide() {
        withAnimation {
            isSideShowing.toggle()
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
                    onFalse()
                } label: {
                    Label(learningState.previousLevel.repeatIntervalLabel, systemImage: "hand.thumbsdown.fill")
                        .foregroundStyle(.red)
                        .frame(minWidth: 75, minHeight: 25)
                }
                .controlSize(.extraLarge)
                
                Button {
                    onTrue()
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
    
    private func onFalse() {
        learningState.decreaseLevel()
        showTranslation = false
    }
    
    private func onTrue() {
        learningState.increaseLevel()
        showTranslation = false
    }
}

#Preview {
    LearningView(list: .init("Preview"))
}

extension VocabularyList {
    typealias LearningWrappedVocabulary = (Learnable, isReverse: Bool)
    
    var learningVocabulariesToday: Array<LearningWrappedVocabulary> {
        //Algorytm
        //1. Newly before Repeatly
        //1.1 Newly: Normal before Reverse
        //1.1.1 nextRepetition sorting
        //1.2 Repeatly: nextRepetition sorting
        
        //All Vocabularies and sort it to learnable Vocabularies
        let vocabularies = vocabularies.filter{ $0.isLearnable }
        
        //Newly Vocabularies
        let newlyVocabularies = vocabularies.filter{ $0.learningState.isNewly && $0.learningState.isNextRepetitionExpired
        }.map {
            return ($0, isReverse: false)
        }.sorted(using: KeyPathComparator(\.0.learningState.nextRepetition))
        
        let newlyReverseVocabularies = vocabularies.filter {
            $0.translatedLearningState.isNewly && $0.translatedLearningState.isNextRepetitionExpired
        }.map {
            return ($0, isReverse: true)
        }.sorted(using: KeyPathComparator(\.0.translatedLearningState.nextRepetition))
        
        //Repeatly Vocabularies
        let repeatlyVocabularies = vocabularies.filter {
            $0.learningState.isRepeatly && $0.learningState.isNextRepetitionExpired
        }.map {
            return ($0, isReverse: false)
        }
        
        let repeatlyReverseVocabularies = vocabularies.filter {
            $0.translatedLearningState.isRepeatly && $0.translatedLearningState.isNextRepetitionExpired
        }.map {
            return ($0, isReverse: true)
        }
        
        //Repeatly Combined and sorted
        let allRepeatlyVocabularies = (repeatlyVocabularies + repeatlyReverseVocabularies).sorted { firstVocabulary, secondVocabulary in
            
            let firstVocabularyNextRepetition: Date
            switch firstVocabulary {
            case (let vocabulary, false):
                firstVocabularyNextRepetition = vocabulary.learningState.nextRepetition
            case (let vocabulary, true):
                firstVocabularyNextRepetition = vocabulary.translatedLearningState.nextRepetition
            }
            
            let secondVocabularyNextRepetition: Date
            switch secondVocabulary {
            case (let vocabulary, false):
                secondVocabularyNextRepetition = vocabulary.learningState.nextRepetition
            case (let vocabulary, true):
                secondVocabularyNextRepetition = vocabulary.translatedLearningState.nextRepetition
            }
            
            if firstVocabularyNextRepetition <= secondVocabularyNextRepetition {
                return true
            }else {
                return false
            }
        }
        
        //Combine all learnable Vocabularies
        let allVocabularies = newlyVocabularies + newlyReverseVocabularies + allRepeatlyVocabularies
        
        return allVocabularies
    }
    
    var learningVocabulariesTodayCount: Int {
        learningVocabulariesToday.count
    }
}
