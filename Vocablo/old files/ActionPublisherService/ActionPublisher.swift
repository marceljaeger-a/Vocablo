//
//  ActionPublisher.swift
//  Vocablo
//
//  Created by Marcel Jäger on 23.01.24.
//

import Foundation
import SwiftUI
import Combine

protocol ActionPublisher {
    ///The subject for a Subscribtion.
    var subject: ActionSubject { get }
    
    ///The result type of the ``ActionSubject``.
    associatedtype SubjectResult
    
    ///The error type of the ``ActionSubject``.
    typealias SubjectFailure = Never
    
    ///A alias for the PassthroughSubject type based on ``SubjectResult`` and ``SubjectFailure``.
    typealias ActionSubject = PassthroughSubject<SubjectResult, SubjectFailure>
    
    func send(_ input: SubjectResult)
}

extension ActionPublisher {
    
    ///Sends the input to the PassthroughSubject´s send methode.
    func send(_ input: SubjectResult) {
        subject.send(input)
    }
}
