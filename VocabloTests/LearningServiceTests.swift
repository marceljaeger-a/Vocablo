//
//  LearningValueManagerTests.swift
//  VocabloTests
//
//  Created by Marcel Jäger on 11.01.24.
//

import XCTest
import SwiftData

@testable import Vocablo

final class LearningServiceTests: XCTestCase {
    
    //MARK: - Properties
    
    var context: ModelContext! = nil

    
    //MARK: - Setup methodes
    
    override func setUpWithError() throws {
        if context == nil {
            let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Deck.self, Vocabulary.self, configurations: configuration)
            
            context = ModelContext(container)
        }
    }

    override func tearDownWithError() throws {
        try context.delete(model: Deck.self)
        try context.save()
    }

    
    //MARK: - Test methodes
    
    func testAlgorithmedLearningValues () throws {
        //Give
        let learningService = LearningService()
        let deck = Deck(name: "Example list", languageOfBase: "German", languageOfTranslation: "English")
        context.insert(deck)
        try context.save()
        
        let vocabulary1 = Vocabulary(baseWord: "Wort 1", baseSentence: "", translationWord: "Word 1", translationSentence: "", isToLearn: true, levelOfBase: .lvl1, levelOfTranslation: .lvl1, sessionsOfBase: [], sessionsOfTranslation: [], nextSessionOfBase: .now, nextSessionOfTranslation: .now)
        deck.vocabularies.append(vocabulary1)
        let vocabulary2 = Vocabulary(baseWord: "Wort 2", baseSentence: "", translationWord: "Word 2", translationSentence: "", isToLearn: true, levelOfBase: .lvl1, levelOfTranslation: .lvl1, sessionsOfBase: [], sessionsOfTranslation: [], nextSessionOfBase: .now, nextSessionOfTranslation: .now)
        deck.vocabularies.append(vocabulary2)
        let vocabulary3 = Vocabulary(baseWord: "Wort 3", baseSentence: "", translationWord: "Word 3", translationSentence: "", isToLearn: true, levelOfBase: .lvl1, levelOfTranslation: .lvl1, sessionsOfBase: [], sessionsOfTranslation: [], nextSessionOfBase: .now, nextSessionOfTranslation: .now)
        deck.vocabularies.append(vocabulary3)
        try context.save()
        
        
        //- Learning simulation
        let value1B = IndexCard(value: vocabulary1, askingSide: .front)    //Should be: 5/6
        value1B.answerTrue()
        value1B.answerTrue()
        
        let value1T = IndexCard(value: vocabulary1, askingSide: .back) //Should be: 3/6
        
        let value2B = IndexCard(value: vocabulary2, askingSide: .front)    //Should be: 1/6

        
        let value2T = IndexCard(value: vocabulary2, askingSide: .back) //Should be: 6/6
        value2T.answerTrue()
        value2T.answerTrue()
        value2T.answerTrue()
        
        let value3B = IndexCard(value: vocabulary3, askingSide: .front)    //Should be: 2/6
        
        let value3T = IndexCard(value: vocabulary3, askingSide: .back) //Should be: 4/6
        
        try context.save()
        

        //When
        let algorythmedValues = learningService.getFilteredSortedIndexCards(of: deck.vocabularies, currentSession: .distantFuture)
        
        //Then
        XCTAssertEqual(algorythmedValues[0].askingPrimaryContent, value2B.askingPrimaryContent)
        XCTAssertEqual(algorythmedValues[1].askingPrimaryContent, value3B.askingPrimaryContent)
        XCTAssertEqual(algorythmedValues[2].askingPrimaryContent, value1T.askingPrimaryContent)
        XCTAssertEqual(algorythmedValues[3].askingPrimaryContent, value3T.askingPrimaryContent)
        XCTAssertEqual(algorythmedValues[4].askingPrimaryContent, value1B.askingPrimaryContent)
        XCTAssertEqual(algorythmedValues[5].askingPrimaryContent, value2T.askingPrimaryContent)
    }
}
