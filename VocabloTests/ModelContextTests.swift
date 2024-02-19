//
//  ModelContextTests.swift
//  VocabloTests
//
//  Created by Marcel Jäger on 08.01.24.
//

import XCTest
import SwiftData

@testable import Vocablo

final class ModelContextTests: XCTestCase {
    
    //MARK: - Properties
    
    var context: ModelContext! = nil
    
    //MARK: - Assisted methodes
    
    func insertExampleLists(count: Int, into context: ModelContext) throws -> Array<VocabularyList> {
        var insertedLists: Array<VocabularyList> = []
        
        for i in 1...count {
            let newList = VocabularyList("List \(i)")
            insertedLists.append(newList)
            context.insert(newList)
        }
        
        try context.save()
        
        return insertedLists
    }
    
    func insertExampleVocabularies(count: Int, into list: VocabularyList) throws -> Array<Vocabulary> {
        var insertedVocabularies: Array<Vocabulary> = []
        
        for i in 1...count {
            let newVocabulary = Vocabulary(baseWord: "Word \(i)", translationWord: "Wort \(i)", wordGroup: .noun)
            insertedVocabularies.append(newVocabulary)
            list.vocabularies.append(newVocabulary)
        }
        
        try context.save()
        
        return insertedVocabularies
    }
    
    func insertExampleData(into context: ModelContext, listCount: Int, vocabularyPerListCount: Int) throws -> Array<VocabularyList> {
        let insertedLists = try insertExampleLists(count: listCount, into: context)
        
        for insertedList in insertedLists {
            _ = try insertExampleVocabularies(count: vocabularyPerListCount, into: insertedList)
        }
        
        return insertedLists
    }

    
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
    
    
    //MARK: - Test Methodes for Deleting

    func testDeletingLists_All() throws {
        //Give
        let insertedLists = try insertExampleData(into: context, listCount: 6, vocabularyPerListCount: 3)
        
        //When
        context.delete(models: insertedLists)
        
        //Then
        XCTAssertNotEqual(insertedLists.count, 0, "Inserted List Count should not be 0")
        
        let fetchedListCount = try context.fetchCount(FetchDescriptor<VocabularyList>())
        XCTAssertEqual(fetchedListCount, 0, "Fetched List Count should be 0")
        
        let fetchedVocabularyCount = try context.fetchCount(FetchDescriptor<Vocabulary>())
        XCTAssertEqual(fetchedVocabularyCount, 0, "Fetched Vocabulary Count should be 0")
    }
    
    func testDeletingLists_Half() throws {
        //Give
        let insertedLists = try insertExampleData(into: context, listCount: 6, vocabularyPerListCount: 3)
        
        var deletingLists: Array<VocabularyList> = []
        for i in 0...2 {
            deletingLists.append(insertedLists[i])
        }
        
        //When
        context.delete(models: deletingLists)
        
        //Then
        let fetchedListCount = try context.fetchCount(FetchDescriptor<VocabularyList>())
        XCTAssertEqual(fetchedListCount, 3, "Fetched List Count should be 3")
        
        let fetchedVocabularyCount = try context.fetchCount(FetchDescriptor<Vocabulary>())
        XCTAssertEqual(fetchedVocabularyCount, 9, "Fetched Vocabulary Count should be 9")
    }
    
    func testDeletingVocabularies_All() throws {
        //Give
        let insertedLists = try insertExampleData(into: context, listCount: 6, vocabularyPerListCount: 3)
        
        let deletingVocabularies = try context.fetch(FetchDescriptor<Vocabulary>())
        
        //When
        context.delete(models: deletingVocabularies)
        
        //Then
        let fetchedVocabularyCount = try context.fetchCount(FetchDescriptor<Vocabulary>())
        XCTAssertEqual(fetchedVocabularyCount, 0, "Fetched Vocabulary Count should be 0")
    }
    
    func testDeletingVocabularies_Half() throws {
        //Give
        let insertedLists = try insertExampleData(into: context, listCount: 6, vocabularyPerListCount: 3)
        
        let vocabularies = try context.fetch(FetchDescriptor<Vocabulary>())
        
        var deletingVocabularies: Array<Vocabulary> = []
        
        for i in 0...8 {
            deletingVocabularies.append(vocabularies[i])
        }
        
        //When
        context.delete(models: deletingVocabularies)
        
        //Then
        let fetchedVocabularyCount = try context.fetchCount(FetchDescriptor<Vocabulary>())
        XCTAssertEqual(fetchedVocabularyCount, 9, "Fetched Vocabulary Count should be 9")
    }
    
    
    //MARK: - Test Methodes for Configurate Learning Functionality
    //- NO Testing
}
