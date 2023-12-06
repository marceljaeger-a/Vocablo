//
//  LearnView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 04.12.23.
//

import SwiftUI

fileprivate extension VocabularyList {
    func learnSideValues(asked: LearnSideValue.AskedWord, filters: Array<(LearnSideValue) -> Bool >, sorting: KeyPathComparator<LearnSideValue>? = nil) -> Array<LearnSideValue> {
       var values = vocabularies.map { element in
            LearnSideValue(learnableObject: element, asked: asked)
        }
        
        for filter in filters {
            values = values.filter(filter)
        }
        
        if let sortingComparator = sorting {
            return values.sorted(using: sortingComparator)
        }else {
            return values
        }
    }
    
    var algorithmedLearnSideValues: Array<LearnSideValue> {
        //1 Newly
        let newlyFilters: Array<(LearnSideValue) -> Bool> = [{ $0.learnableObject.isLearnable }, { $0.state.isNewly }, { $0.state.isNextRepetitionExpired }]
        
        //1.1 Newly with word
        let newlyLearnSideValuesWithWord = learnSideValues(asked: .word, filters: newlyFilters, sorting: KeyPathComparator(\.state.nextRepetition))
        
        //1.2 Newly with translated word
        let newlyLearnSideValueWithTranslatedWord = learnSideValues(asked: .translatedWord, filters: newlyFilters, sorting: KeyPathComparator(\.state.nextRepetition))
        
        
        
        //2 Repeatly
        let repeatlyFilters: Array<(LearnSideValue) -> Bool> = [{ $0.learnableObject.isLearnable }, { $0.state.isRepeatly }, { $0.state.isNextRepetitionExpired }]
        
        //2.1 Repeatly with word
        let repeatlyLeanSideValuesWithWord = learnSideValues(asked: .word, filters: repeatlyFilters)
        
        //2.2 Repeatly with translated word
        let repeatlyLeanSideValuesWithTranslatedWord = learnSideValues(asked: .translatedWord, filters: repeatlyFilters)
        
        //2.3 Repeatly combined
        let repeatlyLearnSideValueCombined = repeatlyLeanSideValuesWithWord + repeatlyLeanSideValuesWithTranslatedWord
        
        let repeatlyLearnSideValueCombinedSorted = repeatlyLearnSideValueCombined.sorted(using: KeyPathComparator(\.state.nextRepetition))
        
        
        
        //3 Combined in right sorting
        //- 1. Newly with word
        //- 2. Newly with translated word
        //- 3. Repeatly combined
        let combinedLearnSideValue = newlyLearnSideValuesWithWord + newlyLearnSideValueWithTranslatedWord + repeatlyLearnSideValueCombinedSorted
        
        return combinedLearnSideValue
    }
}

fileprivate struct LearnSideValueCountKey: EnvironmentKey {
    static var defaultValue: Int = 0
}
fileprivate extension EnvironmentValues {
    var learnSideValueCount: Int {
        get {
            self[LearnSideValueCountKey.self]
        }
        set {
            self[LearnSideValueCountKey.self] = newValue
        }
    }
}

@propertyWrapper
struct LearnSideValue {
    enum AskedWord {
        case word, translatedWord
    }
    
    var learnableObject: Learnable
    var asked: AskedWord
    
    var wrappedValue: Learnable {
        get {
            return learnableObject
        }
        set {
            learnableObject = newValue
        }
    }
    
    var projectedValue: LearnSideValue {
        self
    }
    
    var askedWord: String {
        switch asked {
        case .word:
            learnableObject.word
        case .translatedWord:
            learnableObject.translatedWord
        }
    }
    
    var askedSentence: String {
        switch asked {
        case .word:
            learnableObject.sentence
        case .translatedWord:
            learnableObject.translatedSentence
        }
    }
    
    var answeredWord: String {
        switch asked {
        case .word:
            learnableObject.translatedWord
        case .translatedWord:
            learnableObject.word
        }
    }
    
    var answeredSentence: String {
        switch asked {
        case .word:
            learnableObject.translatedSentence
        case .translatedWord:
            learnableObject.sentence
        }
    }
    
    var state: LearningState {
        get {
            switch asked {
            case .word:
                learnableObject.learningState
            case .translatedWord:
                learnableObject.translatedLearningState
            }
        }
    }
    
    var nextRepeatIntervalLabel: String {
        state.nextLevel.repeatIntervalLabel
    }
    
    var previousRepeatIntervalLabel: String {
        state.previousLevel.repeatIntervalLabel
    }
    
    func answerTrue() {
        switch asked {
        case .word:
            learnableObject.learningState.increaseLevel()
        case .translatedWord:
            learnableObject.translatedLearningState.increaseLevel()
        }
    }
    
    func answerFalse() {
        switch asked {
        case .word:
            learnableObject.learningState.decreaseLevel()
        case .translatedWord:
            learnableObject.translatedLearningState.decreaseLevel()
        }
    }
}

@propertyWrapper
struct OpacityBool {
    var wrappedValue: Bool
    let trueValue: Double
    let falseValue: Double
    
    var projectedValue: Double {
        switch wrappedValue {
        case true:
            return trueValue
        case false:
            return falseValue
        }
    }
}
extension OpacityBool {
    init(wrappedValue: Bool, onTrue: Double = 1, onFalse: Double = 0) {
        self.init(wrappedValue: wrappedValue, trueValue: onTrue, falseValue: onFalse)
    }
}

struct LearnView:View {
    let list: VocabularyList
    
    var body: some View {
        if let firstValue = list.algorithmedLearnSideValues.first {
            LearnObjectView(value: firstValue, isNew: OpacityBool(wrappedValue: firstValue.state.isNewly))
                .environment(\.learnSideValueCount, list.algorithmedLearnSideValues.count)
        }else {
            ContentUnavailableView("No vocabulary to learn today!", systemImage: "calendar.badge.checkmark")
                .padding()
                #warning("The reason of the console print `=== AttributeGraph: cycle detected through attribute 662336 ===` is the ContentUnavailableView! I do not why this is so, because when I put this View into the sheet modifier alone, this message is also printed in the console. Maybe it is a SwiftUI Bug! But this is only in a sheet. For example in a popover it is not. I test it on an iOS Project and it did not print. On a another macOS App with only a button it did print also!")
        }
    }
}

struct LearnObjectView: View {
    @LearnSideValue var value: Learnable
    @OpacityBool var isNew: Bool
    
    @State var isOverlapping: Bool = true
    
    var body: some View {
        VStack {
            NewVocabularyLabel()
                .opacity($isNew)
            
            //Word
            WordView(word: $value.askedWord, sentence: $value.askedSentence)
                .frame(minHeight: 175)
            
            Divider()
            
            //Translation
            WordView(word: $value.answeredWord, sentence: $value.answeredSentence)
                .frame(minHeight: 175)
                .questionOverlay(isOverlapping: $isOverlapping)
            
            Spacer()
            
            //Answer
            AnswerView(value: $value, isOverlapping: $isOverlapping)
        }
        .frame(width: 600, height: 500)
        .padding()
    }
}

fileprivate struct QuestionOverlayModfier: ViewModifier {
    @Binding var isOverlapping: Bool
    
    func body(content: Content) -> some View {
        let contextOpacity: Double = isOverlapping ? 0 : 1
        let overlayOpacity: Double = isOverlapping ? 1 : 0
        
        return content.opacity(contextOpacity).overlay {
            Button {
                withAnimation {
                    isOverlapping = false
                }
            } label: {
                Image(systemName: "questionmark")
                    .imageScale(.large)
                    .font(.largeTitle)
                    .fontDesign(.rounded)
                    .bold()
                    .opacity(overlayOpacity)
            }
            .buttonStyle(.plain)
        }
    }
}
fileprivate extension View {
    func questionOverlay(isOverlapping: Binding<Bool>) -> some View {
        self.modifier(QuestionOverlayModfier(isOverlapping: isOverlapping))
    }
}

fileprivate struct WordView: View {
    let word: String
    let sentence: String
    
    var body: some View {
        VStack(spacing: 25){
            Text(word)
                .font(.largeTitle)
                .fontDesign(.rounded)
                .bold()
            
            Text(sentence)
                .font(.title3)
                .fontDesign(.rounded)
                .foregroundStyle(.secondary)
        }
    }
}

fileprivate struct NewVocabularyLabel: View {
    var body: some View {
        Text("New card!")
            .font(.headline)
            .fontDesign(.rounded)
            .bold()
            .foregroundStyle(.blue.gradient)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(.blue.opacity(0.2), in: .rect(cornerRadius: 8))
    }
}

fileprivate struct AnswerView: View {
    @LearnSideValue var value: Learnable
    @Binding var isOverlapping: Bool
    
    @Environment(\.learnSideValueCount) var valueCount: Int
    
    var body: some View {
        VStack(spacing: 10){
            Text("\(valueCount) words left")
                .font(.callout)
                .fontDesign(.rounded)
                .foregroundStyle(.tertiary)
            
            HStack(spacing: 15){
                Button {
                    $value.answerFalse()
                    isOverlapping = true
                } label: {
                    Label($value.previousRepeatIntervalLabel, systemImage: "hand.thumbsdown")
                        .foregroundStyle(.red.gradient)
                        .frame(width: 65)
                }
                
                Button {
                    $value.answerTrue()
                    isOverlapping = true
                } label: {
                    Label($value.nextRepeatIntervalLabel, systemImage: "hand.thumbsup")
                        .foregroundStyle(.green.gradient)
                        .frame(width: 65)
                }

            }
            .buttonStyle(.bordered)
            .controlSize(.extraLarge)
        }
    }
}

#Preview {
    LearnObjectView(value: LearnSideValue(learnableObject: Vocabulary(word: "the tree", translatedWord: "der Baum", sentence: "This is a nature contruct.", translatedSentence: "Das ist ein Naturkonstrukt!", wordGroup: .noun), asked: .word), isNew: OpacityBool(wrappedValue: true, onTrue: 1, onFalse: 0))
}
