//
//  LearningValueManagerTests.swift
//  VocabloTests
//
//  Created by Marcel Jäger on 11.01.24.
//

import XCTest
import SwiftData

@testable import Vocablo

final class LearningValueManagerTests: XCTestCase {
    
    //MARK: - Properties
    
    var context: ModelContext! = nil

    
    //MARK: - Setup methodes
    
    override func setUpWithError() throws {
        if context == nil {
            let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: VocabularyList.self, Vocabulary.self, configurations: configuration)
            
            context = ModelContext(container)
        }
    }

    override func tearDownWithError() throws {
        try context.delete(model: VocabularyList.self)
        try context.save()
    }

    
    //MARK: - Test methodes
    
    func testAlgorithmedLearningValues () throws {
        //Give
        let valueManager = LearningValueManager()
        let list = VocabularyList("Example list")
        context.insert(list)
        try context.save()
        
        let vocabulary1 = Vocabulary(baseWord: "Word 1", translationWord: "Wort 1", wordGroup: .noun)
        list.addVocabulary(vocabulary1)
        let vocabulary2 = Vocabulary(baseWord: "Word 2", translationWord: "Wort 2", wordGroup: .noun)
        list.addVocabulary(vocabulary2)
        let vocabulary3 = Vocabulary(baseWord: "Word 3", translationWord: "Wort 3", wordGroup: .noun)
        list.addVocabulary(vocabulary3)
        context.checkToLearn(of: list.vocabularies)
        try context.save()
        
        
        //- Learning simulation
        let value1B = LearningValue(learnableObject: vocabulary1, asking: .base)    //Should be: 5/6
        value1B.answerTrue()
        value1B.answerTrue()
        vocabulary1.baseState.lastRepetition = .now - 60*60*24*365
        
        let value1T = LearningValue(learnableObject: vocabulary1, asking: .translation) //Should be: 2/6
        
        let value2B = LearningValue(learnableObject: vocabulary2, asking: .base)    //Should be: 3/6
        vocabulary2.baseState.lastRepetition = .now - 60*60*24*367
        
        let value2T = LearningValue(learnableObject: vocabulary2, asking: .translation) //Should be: 6/6
        value2T.answerTrue()
        value2T.answerTrue()
        value2T.answerTrue()
        vocabulary2.translationState.lastRepetition = .now - 60*60*24*365
        
        let value3B = LearningValue(learnableObject: vocabulary3, asking: .base)    //Should be: 1/6
        
        let value3T = LearningValue(learnableObject: vocabulary3, asking: .translation) //Should be: 4/6
        vocabulary3.translationState.lastRepetition = .now - 60*60*24*366
        
        try context.save()
        

        //When
        let algorythmedValues = valueManager.algorithmedLearningValues(of: list.vocabularies)
        
        //Then
        XCTAssertEqual(algorythmedValues[0].askingWord, value3B.askingWord)
        XCTAssertEqual(algorythmedValues[1].askingWord, value1T.askingWord)
        XCTAssertEqual(algorythmedValues[2].askingWord, value2B.askingWord)
        XCTAssertEqual(algorythmedValues[3].askingWord, value3T.askingWord)
        XCTAssertEqual(algorythmedValues[4].askingWord, value1B.askingWord)
        XCTAssertEqual(algorythmedValues[5].askingWord, value2T.askingWord)
    }
}
