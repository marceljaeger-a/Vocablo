//
//  VocabloTests.swift
//  VocabloTests
//
//  Created by Marcel Jäger on 08.01.24.
//

import XCTest
import SwiftData

@testable import Vocablo

final class LearningValueTests: XCTestCase {
    
    //MARK: - Properties
    
    var context: ModelContext! = nil
    var exampleVocabulary: Vocabulary! = nil
    
    var exampleValueWithAskedBase: LearningValue {
        LearningValue(learnableObject: exampleVocabulary, asking: .base)
    }
    
    var exampleValueWithAskedTranslation: LearningValue {
        LearningValue(learnableObject: exampleVocabulary, asking: .translation)
    }
    
    
    //MARK: - Setup methodes
    
    override func setUpWithError() throws {
        if context == nil {
            let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: VocabularyList.self, Vocabulary.self, configurations: configuration)
            
            context = ModelContext(container)
        }
        
        let exampleVocabulary = Vocabulary(baseWord: "the technology", translationWord: "die Technologie", wordGroup: .noun)
        context.insert(exampleVocabulary)
        try context.save()
        self.exampleVocabulary = exampleVocabulary
    }

    override func tearDownWithError() throws {
        try context.delete(model: Vocabulary.self)
        try context.save()
        self.exampleVocabulary = nil
    }

    
    //MARK: - Test methodes
    
    func testReturnAskingWord() throws {
        //Give
        let valueWithAskedBase = exampleValueWithAskedBase
        let valueWithAskedTranslation = exampleValueWithAskedTranslation
        
        //When
        let askingWordWithAskedBase = valueWithAskedBase.askingWord
        let askingWordWithAskedTranslation = valueWithAskedTranslation.askingWord
        
        //Then
        XCTAssertEqual(askingWordWithAskedBase, exampleVocabulary.baseWord, "askingWordWithAskedBase schould be \(exampleVocabulary.baseWord)")
        XCTAssertEqual(askingWordWithAskedTranslation, exampleVocabulary.translationWord, "askingWordWithAskedTranslation schould be \(exampleVocabulary.translationWord)")
    }

    func testReturnAskingSentence() throws {
        //Give
        let valueWithAskedBase = exampleValueWithAskedBase
        let valueWithAskedTranslation = exampleValueWithAskedTranslation
        
        //When
        let askingSentenceWithAskedBase = valueWithAskedBase.askingSentence
        let askingSentenceWithAskedTranslation = valueWithAskedTranslation.askingSentence
        
        //Then
        XCTAssertEqual(askingSentenceWithAskedBase, exampleVocabulary.baseSentence, "askingSentenceWithAskedBase schould be \(exampleVocabulary.baseSentence)")
        XCTAssertEqual(askingSentenceWithAskedTranslation, exampleVocabulary.translationSentence, "askingSentenceWithAskedTranslation schould be \(exampleVocabulary.translationSentence)")
    }
    
    func testReturnAnsweringWord() throws {
        //Give
        let valueWithAskedBase = exampleValueWithAskedBase
        let valueWithAskedTranslation = exampleValueWithAskedTranslation
        
        //When
        let answeringWordWithAskedBase = valueWithAskedBase.answeringWord
        let answeringWordWithAskedTranslation = valueWithAskedTranslation.answeringWord
        
        //Then
        XCTAssertEqual(answeringWordWithAskedBase, exampleVocabulary.translationWord, "answeringWordWithAskedBase schould be \(exampleVocabulary.translationWord)")
        XCTAssertEqual(answeringWordWithAskedTranslation, exampleVocabulary.baseWord, "answeringWordWithAskedTranslation schould be \(exampleVocabulary.baseWord)")
    }
    
    func testReturnAnsweringSentence() throws {
        //Give
        let valueWithAskedBase = exampleValueWithAskedBase
        let valueWithAskedTranslation = exampleValueWithAskedTranslation
        
        //When
        let answeringSentenceWithAskedBase = valueWithAskedBase.answeringSentence
        let answeringSentenceWithAskedTranslation = valueWithAskedTranslation.answeringSentence
        
        //Then
        XCTAssertEqual(answeringSentenceWithAskedBase, exampleVocabulary.translationSentence, "answeringSentenceWithAskedBase schould be \(exampleVocabulary.translationSentence)")
        XCTAssertEqual(answeringSentenceWithAskedTranslation, exampleVocabulary.baseSentence, "answeringSentenceWithAskedTranslation schould be \(exampleVocabulary.baseSentence)")
    }
    
    func testReturnAskingState() throws {
        //Give
        let valueWithAskedBase = exampleValueWithAskedBase
        let valueWithAskedTranslation = exampleValueWithAskedTranslation
        
        //When
        let askingStateWithAskedBase = valueWithAskedBase.askingState
        let askingStateWithAskedTranslation = valueWithAskedTranslation.askingState
        
        //Then
        XCTAssertEqual(askingStateWithAskedBase, exampleVocabulary.baseState, "askingStateWithAskedBase schould be the baseState of exampleVocabulary")
        XCTAssertEqual(askingStateWithAskedTranslation, exampleVocabulary.translationState, "askingStateWithAskedBase schould be the translationState of exampleVocabulary")
    }

    func testAnswerTrue() throws {
        //Give
        let valueWithAskedBase = exampleValueWithAskedBase
        let askingStateBefore = valueWithAskedBase.askingState
        
        //When
        valueWithAskedBase.answerTrue()
        try context.save()
        
        //Then
        let askingStateAfter = valueWithAskedBase.askingState
        
        XCTAssertTrue(askingStateBefore.isNewly, "askingStateBefore should be newly")
        XCTAssertFalse(askingStateBefore.isRepeatly, "askingStateBefore should not be repeatly")
        
        XCTAssertFalse(askingStateAfter.isNewly, "askingStateAfter should not be newly")
        XCTAssertTrue(askingStateAfter.isRepeatly, "askingStateAfter should be repeatly")
        
        XCTAssertNil(askingStateBefore.lastRepetition, "lastRepetition of askingStateBefore should be nil")
        XCTAssertNotNil(askingStateAfter.lastRepetition, "lastRepetition of askingStateAfter should not be nil")
        
        XCTAssertEqual(askingStateBefore.level, .lvl1, "level of askingStateBefore should be lvl1")
        XCTAssertEqual(askingStateAfter.level, .lvl2, "level of askingStateBefore should be lvl2")
    }
    
    func testAnswerTrueAndThenFalse() throws {
        //Give
        let valueWithAskedBase = exampleValueWithAskedBase
        valueWithAskedBase.answerTrue()
        let askingStateBefore = valueWithAskedBase.askingState
        
        //When
        valueWithAskedBase.answerFalse()
        try context.save()
        
        //Then
        let askingStateAfter = valueWithAskedBase.askingState
        
        XCTAssertTrue(askingStateAfter.isRepeatly, "askingStateAfter should be repeatly")
        
        XCTAssertEqual(askingStateBefore.repetitionCount, 1, "repetitionCount of askingStateBefore should be 1")
        XCTAssertEqual(askingStateAfter.repetitionCount, 2, "repetitionCount of askingStateAfter should be 2")
        
        XCTAssertEqual(askingStateBefore.level, .lvl2, "level of askingStateBefore should be lvl2")
        XCTAssertEqual(askingStateAfter.level, .lvl1, "level of askingStateBefore should be lvl1")
    }
}
