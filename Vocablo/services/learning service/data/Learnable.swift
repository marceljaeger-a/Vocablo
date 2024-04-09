//
//  Learnable.swift
//  Vocablo
//
//  Created by Marcel Jäger on 28.10.23.
//

import Foundation

protocol Learnable: AnyObject {
    var baseState: LearningState { get set }
    var translationState: LearningState { get set }
    
    var basePrimaryContent: String { get set }
    var translationPrimaryContent: String { get set }
    
    var baseSecondaryContent: String { get set }
    var translationSecondaryContent: String { get  set }
}




