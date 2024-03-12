//
//  Set.swift
//  Vocablo
//
//  Created by Marcel Jäger on 05.01.24.
//

import Foundation

extension Set  {
    mutating func remove(members: Set<Element>) -> Set<Element> {
        var removedMembers: Set<Element> = []
        
        for member in members {
            let removedMember = self.remove(member)
            if let removedMember {
                removedMembers.insert(removedMember)
            }
        }
        
        return removedMembers
    }
}
