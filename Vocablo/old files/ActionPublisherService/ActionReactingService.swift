//
//  ActionPublisherService.swift
//  Vocablo
//
//  Created by Marcel Jäger on 23.01.24.
//

import Foundation

///Defines and manages your ActionPublishers.
///
///The ``ActionReactingServiceKey`` has a default value, so you can directly create a property with the Envrionment Property Wrapper and with the EnvrionmentKey to get the default instance from the View Environment.
///
///The ``OnActionModifier`` uses this instance too. So you also do not need to commit refer to an instance while you use the View Modifer.
///
///If you want to learn more about how you use the API in the App read <doc:Essentials-of-ActionReactingService>.
final class ActionReactingService {
    
    //MARK: - Properties = ActionPublisher
    
    ///The Publisher for adding a new ``Vocabulary``.
    let addingVocabulary = AddingVocabularPublisher()
    
    ///The Publisher for adding a new ``VocabularyList``.
    let addingList = AddingVocabularyListPublisher()
    
    //MARK: - Initialiser
    
    init() {
        
    }
    
    //MARK: - Methodes
    
    ///Sends an input to the wrapped send methode of the particular ActionPublisher which sends the input further its PasstroughSubject.
    ///- Parameters:
    ///     - action: Choose the action that should send a value to its subscribers.
    ///     - input: Is the value that you want to send to the subscribers.
    final func send<A: ActionPublisher>(action: KeyPath<ActionReactingService, A>, input: A.SubjectResult) {
        self[keyPath: action].send(input)
    }
}

