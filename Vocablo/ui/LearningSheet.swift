//
//  LearnView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 04.12.23.
//

import SwiftUI

//MARK: - LearningSheet -

struct LearningSheet: View {
    
    //MARK: - Properties
    
    let learningList: VocabularyList
    private let learningManager: LearningValueManager
    
    //MARK: - Initialiser
    
    init(list: VocabularyList) {
        self.learningList = list
        self.learningManager = LearningValueManager(managingList: list)
    }
    
    //MARK: - Body
    
    var body: some View {
        if let firstValue = learningManager.algorithmedLearnSideValues.first {
            LearningPage(value: firstValue, isWordNew: OpacityBool(wrappedValue: firstValue.state.isNewly))
                .environment(\.learningValuesCount, learningManager.algorithmedLearnSideValues.count)
        }else {
            NoVocabularyToLearnTodayView()
        }
    }
}



//MARK: - Subviews

extension LearningSheet {
    struct NoVocabularyToLearnTodayView: View {
        var body: some View {
            ContentUnavailableView("No vocabulary to learn today!", systemImage: "calendar.badge.checkmark")
                .padding()
        }
    }
}



//MARK: - LearnPage -

struct LearningPage: View {
    
    //MARK: - Properties
    
    @LearningValue var value: Learnable
    @OpacityBool var isWordNew: Bool
    
    @State private var isOverlapping: Bool = true
    
    //MARK: - Body
    
    var body: some View {
        VStack {
            NewWordLabel()
                .opacity($isWordNew)
            
            //Word
            WordView(word: $value.askedWord, sentence: $value.askedSentence)
                .frame(minHeight: 175)
            
            Divider()
            
            //Translation
            WordView(word: $value.answeredWord, sentence: $value.answeredSentence)
                .frame(minHeight: 175)
                .overlappedQuestionMark(isOverlapping: $isOverlapping)
            
            Spacer()
            
            //Answer
            AnswerView(value: $value, isOverlapping: $isOverlapping)
        }
        .frame(width: 600, height: 500)
        .padding()
    }
}



//MARK: - Subviews

extension LearningPage {
    struct WordView: View {
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
    
    struct NewWordLabel: View {
        var body: some View {
            Text("New word!")
                .font(.headline)
                .fontDesign(.rounded)
                .bold()
                .foregroundStyle(.blue.gradient)
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(.blue.opacity(0.2), in: .rect(cornerRadius: 8))
        }
    }
    
    struct AnswerView: View {
        @LearningValue var value: Learnable
        @Binding var isOverlapping: Bool
        
        @Environment(\.learningValuesCount) private var valuesCount: Int
        
        var body: some View {
            VStack(spacing: 10){
                Text("\(valuesCount) words left")
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
}



//MARK: - ViewModifiers

fileprivate struct OverlappingQuestionMarkModfier: ViewModifier {
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
                    .symbolEffect(.pulse)
                    .imageScale(.large)
                    .font(.largeTitle)
                    .fontDesign(.rounded)
                    .bold()
                    .opacity(overlayOpacity)
            }
            .buttonStyle(.plain)
            .keyboardShortcut(KeyEquivalent("d"), modifiers: .command)
        }
    }
}

fileprivate extension View {
    func overlappedQuestionMark(isOverlapping: Binding<Bool>) -> some View {
        self.modifier(OverlappingQuestionMarkModfier(isOverlapping: isOverlapping))
    }
}



//MARK: - EnvrionmentValues

fileprivate extension EnvironmentValues {
    struct LearningValuesCount: EnvironmentKey {
        static var defaultValue: Int = 0
    }
    
    var learningValuesCount: Int {
        get {
            self[LearningValuesCount.self]
        }
        set {
            self[LearningValuesCount.self] = newValue
        }
    }
}



//MARK: - Preview

#Preview {
    LearningPage(value: LearningValue(learnableObject: Vocabulary(word: "the tree", translatedWord: "der Baum", sentence: "This is a nature contruct.", translatedSentence: "Das ist ein Naturkonstrukt!", wordGroup: .noun), asking: .word), isWordNew: OpacityBool(wrappedValue: true, onTrue: 1, onFalse: 0))
}
