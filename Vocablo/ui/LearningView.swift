//
//  LearningView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 28.10.23.
//

import SwiftUI

struct LearningView: View {
    let list: VocabularyList
    
    var learningVocabularies: Array<Vocabulary> {
        let vocabularies = list.vocabularies.filter { vocabulary in
            vocabulary.toLearnToday
        }
        return vocabularies.sorted(using: KeyPathComparator(\Vocabulary.learningState.nextRepetition))
    }
    
    var body: some View {
        if let firstLearningVocabulary = learningVocabularies.first {
            LearnableView(learnable: firstLearningVocabulary, vocabularyCount: learningVocabularies.count)
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
    
    var body: some View {
        VStack(spacing: 20) {
            VocabularyLearningSideView(word: learnable.learningContext.word, sentence: learnable.learningContext.sentence)
            
            VocabularyLearningSideView(word: learnable.learningContext.translatedWord, sentence: learnable.learningContext.translatedSentence, showSide: $showTranslation)
        }
        .padding()
        .frame(width: 1000, height: 800)
        .overlay {
            VocabularyLearningAnswersView(learnable: learnable, vocabularyCount: vocabularyCount, showTranslation: $showTranslation)
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
    let learnable: Learnable
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
                    learnable.levelDown()
                    showTranslation = false
                } label: {
                    Label(learnable.downLevel.repeatIntervalLabel, systemImage: "hand.thumbsdown.fill")
                        .foregroundStyle(.red)
                        .frame(minWidth: 75, minHeight: 25)
                }
                .controlSize(.extraLarge)
                
                Button {
                    learnable.levelUp()
                    showTranslation = false
                } label: {
                    Label(learnable.nextLevel.repeatIntervalLabel, systemImage: "hand.thumbsup.fill")
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
