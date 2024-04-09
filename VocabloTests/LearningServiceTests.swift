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
        let learningService = LearningService()
        let list = VocabularyList("Example list")
        context.insert(list)
        try context.save()
        
        let vocabulary1 = Vocabulary(baseWord: "Word 1", translationWord: "Wort 1", wordGroup: .noun)
        list.append(vocabulary: vocabulary1)
        let vocabulary2 = Vocabulary(baseWord: "Word 2", translationWord: "Wort 2", wordGroup: .noun)
        list.append(vocabulary: vocabulary2)
        let vocabulary3 = Vocabulary(baseWord: "Word 3", translationWord: "Wort 3", wordGroup: .noun)
        list.append(vocabulary: vocabulary3)
        list.vocabularies.forEach { $0.isToLearn = true }
        try context.save()
        
        
        //- Learning simulation
        let value1B = LearningValue(value: vocabulary1, askingContent: .base)    //Should be: 5/6
        value1B.answerTrue()
        value1B.answerTrue()
        vocabulary1.baseState.lastRepetition = .now - 60*60*24*365
        
        let value1T = LearningValue(value: vocabulary1, askingContent: .translation) //Should be: 2/6
        
        let value2B = LearningValue(value: vocabulary2, askingContent: .base)    //Should be: 3/6
        vocabulary2.baseState.lastRepetition = .now - 60*60*24*367
        
        let value2T = LearningValue(value: vocabulary2, askingContent: .translation) //Should be: 6/6
        value2T.answerTrue()
        value2T.answerTrue()
        value2T.answerTrue()
        vocabulary2.translationState.lastRepetition = .now - 60*60*24*365
        
        let value3B = LearningValue(value: vocabulary3, askingContent: .base)    //Should be: 1/6
        
        let value3T = LearningValue(value: vocabulary3, askingContent: .translation) //Should be: 4/6
        vocabulary3.translationState.lastRepetition = .now - 60*60*24*366
        
        try context.save()
        

        //When
        let algorythmedValues = learningService.getLearnignValues(of: list.vocabularies)
        
        //Then
        XCTAssertEqual(algorythmedValues[0].askingPrimaryContent, value3B.askingPrimaryContent)
        XCTAssertEqual(algorythmedValues[1].askingPrimaryContent, value1T.askingPrimaryContent)
        XCTAssertEqual(algorythmedValues[2].askingPrimaryContent, value2B.askingPrimaryContent)
        XCTAssertEqual(algorythmedValues[3].askingPrimaryContent, value3T.askingPrimaryContent)
        XCTAssertEqual(algorythmedValues[4].askingPrimaryContent, value1B.askingPrimaryContent)
        XCTAssertEqual(algorythmedValues[5].askingPrimaryContent, value2T.askingPrimaryContent)
    }
}
