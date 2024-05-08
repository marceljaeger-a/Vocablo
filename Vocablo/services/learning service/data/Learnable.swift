//
//  Learnable.swift
//  Vocablo
//
//  Created by Marcel Jäger on 28.10.23.
//

import Foundation

protocol Learnable: AnyObject {
    var primaryContentOfFront: String { get set }
    var secondaryContentOfFront: String { get set }
    var primaryContentOfBack: String { get set }
    var secondaryContentOfBack: String { get set }
    
    var levelOfFront: LearningLevel { get set }
    var levelOfBack: LearningLevel { get set }
    var sessionsOfFront: Array<Date> { get set }
    var sessionsOfBack: Array<Date> { get set }
    
    func answerTrue(askingSide: IndexCard<Self>.Side)
    func answerWrong(askingSide: IndexCard<Self>.Side)
}




