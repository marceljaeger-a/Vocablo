//
//  AddVocabularPublisher.swift
//  Vocablo
//
//  Created by Marcel Jäger on 23.01.24.
//

import Foundation
import Combine

struct AddingVocabularPublisher: ActionPublisher {
    typealias SubjectResult = Vocabulary
    var subject: ActionSubject = PassthroughSubject()
}
