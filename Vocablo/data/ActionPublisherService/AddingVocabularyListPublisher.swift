//
//  AddingVocabularyListPublisher.swift
//  Vocablo
//
//  Created by Marcel Jäger on 23.01.24.
//

import Foundation
import Combine

struct AddingVocabularyListPublisher: ActionPublisher {
    typealias SubjectResult = VocabularyList
    var subject: ActionSubject = PassthroughSubject()
}