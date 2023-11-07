//
//  LearningView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 28.10.23.
//

import SwiftUI


struct LearningView: View {
    let list: VocabularyList
    
    var learningVocabularies: Array<(Vocabulary, isReverse: Bool)> {
        //Algorytm
        //1. Newly before Repeatly
            //1.1 Newly: Normal before Reverse
                //1.1.1 nextRepetition sorting
            //1.2 Repeatly: nextRepetition sorting
        
        //All Vocabularies and sort it to learnable Vocabularies
        let vocabularies = list.vocabularies.filter{ $0.isLearnable }
        
        //Newly Vocabularies
        let newlyVocabularies = vocabularies.filter{ $0.learningState.isNewly && $0.learningState.toLearnToday
        }.map {
            return ($0, isReverse: false)
        }.sorted(using: KeyPathComparator(\.0.learningState.nextRepetition))
        
        let newlyReverseVocabularies = vocabularies.filter {
            $0.translatedLearningState.isNewly && $0.translatedLearningState.toLearnToday
        }.map {
            return ($0, isReverse: true)
        }.sorted(using: KeyPathComparator(\.0.translatedLearningState.nextRepetition))
        
        //Repeatly Vocabularies
        let repeatlyVocabularies = vocabularies.filter {
            $0.learningState.isRepeatly && $0.learningState.toLearnToday
        }.map {
            return ($0, isReverse: false)
        }
        
        let repeatlyReverseVocabularies = vocabularies.filter {
            $0.translatedLearningState.isRepeatly && $0.translatedLearningState.toLearnToday
        }.map {
            return ($0, isReverse: true)
        }
        
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
    
    var body: some View {
        if let firstLearningVocabulary = learningVocabularies.first {
            if firstLearningVocabulary.isReverse {
                LearnableView(learnable: firstLearningVocabulary.0, vocabularyCount: learningVocabularies.count, reverse: true)
            }else {
                LearnableView(learnable: firstLearningVocabulary.0, vocabularyCount: learningVocabularies.count, reverse: false)
            }
        }else {
            ContentUnavailableView("No vocabulary to learn today!", systemImage: "calendar.badge.checkmark")
        }
    }
}

fileprivate struct LearnableView: View {
    @State var showTranslation: Bool = false
    var translationViewOpacity: Double {
        if showTranslation {
            return 1.0
        }
        return 0.0
    }
    
    var learnable: Learnable
    let vocabularyCount: Int
    let reverse: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            if reverse {
                VocabularyLearningSideView(word: learnable.translatedWord, sentence: learnable.translatedSentence)
                
                VocabularyLearningSideView(word: learnable.word, sentence: learnable.sentence, showSide: $showTranslation)
            }else {
                VocabularyLearningSideView(word: learnable.word, sentence: learnable.sentence)
                
                VocabularyLearningSideView(word: learnable.translatedWord, sentence: learnable.translatedSentence, showSide: $showTranslation)
            }
        }
        .padding()
        .frame(width: 1000, height: 800)
        .overlay {
            if reverse {
                VocabularyLearningAnswersView(
                    learningState: Binding(get: {
                        learnable.translatedLearningState
                    }, set: { value in
                        learnable.translatedLearningState = value
                    }),
                    vocabularyCount: vocabularyCount,
                    showTranslation: $showTranslation
                )
            }else {
                VocabularyLearningAnswersView(
                    learningState: Binding(get: {
                        learnable.learningState
                    }, set: { value in
                        learnable.learningState = value
                    }),
                    vocabularyCount: vocabularyCount,
                    showTranslation: $showTranslation
                )
            }
        }
    }
}

fileprivate struct VocabularyLearningSideView: View {
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

fileprivate struct VocabularyLearningAnswersView: View {
    @Binding var learningState: LearningState
    let vocabularyCount: Int
    @Binding var showTranslation: Bool
    
    var body: some View {
        VStack {
            HStack{
               Spacer()
                Text("\(vocabularyCount)")
                    .font(.title3)
                    .fontDesign(.monospaced)
                    .foregroundStyle(.secondary)
            }
            
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
