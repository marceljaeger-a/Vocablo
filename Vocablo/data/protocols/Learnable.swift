//
//  Learnable.swift
//  Vocablo
//
//  Created by Marcel Jäger on 28.10.23.
//

import Foundation

protocol Learnable: AnyObject {
    var isToLearn: Bool { get set }
    var baseState: LearningState { get set }
    var translationState: LearningState { get set }
    var baseWord: String { get set }
    var translationWord: String { get set }
    var baseSentence: String { get set }
    var translationSentence: String { get  set }
    var baseExplenation: String { get }
}

extension Learnable {
    func checkToLearn() {
        guard isToLearn == false else { return }
        self.isToLearn = true
    }
    
    func uncheckToLearn() {
        guard isToLearn == true else { return }
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



