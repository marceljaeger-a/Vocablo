//
//  Learnable.swift
//  Vocablo
//
//  Created by Marcel Jäger on 28.10.23.
//

import Foundation

protocol Learnable: AnyObject {
    var isToLearn: Bool { get set }
    var learningState: LearningState { get set }
    var translatedLearningState: LearningState { get set }
    var word: String { get set }
    var translatedWord: String { get set }
    var sentence: String { get set }
    var translatedSentence: String { get  set }
    var explenation: String { get }
}

extension Learnable {
    func checkToLearn() {
        self.isToLearn = true
    }
    
    func uncheckToLearn() {
        self.isToLearn = false
    }
    
    func toogleToLearn() {
        if isToLearn {
            uncheckToLearn()
        }else {
            checkToLearn()
        }
    }
}



