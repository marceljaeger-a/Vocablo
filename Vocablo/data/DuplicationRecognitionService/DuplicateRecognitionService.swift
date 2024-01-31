//
//  DuplicationRecognitionService.swift
//  Vocablo
//
//  Created by Marcel Jäger on 30.01.24.
//

import Foundation

struct DuplicateRecognitionService {
    ///Returns true if there exists a duplciacte within the Array.
    func existDuplicate<V: Duplicateable>(of value: V, within otherValues: Array<V>) -> Bool {
        for otherValue in otherValues {
            if V.isDuplicate(lhs: value, rhs: otherValue) {
                return true
            }
        }
        
        return false
    }
    
    ///Returns values with duplicates within the Array.
    func valuesWithDuplicate<V: Duplicateable>(within otherValues: Array<V>) -> Array<V> {
        var duplicates: Array<V> = []
        
        for otherValue in otherValues {
            if self.existDuplicate(of: otherValue, within: otherValues) {
                duplicates.append(otherValue)
            }
        }
        
        return duplicates
    }
    
    ///Returns duplicates of the value within the Array.
    func duplicates<V: Duplicateable>(of value: V, within otherValues: Array<V>) -> Array<V> {
        var duplicates: Array<V> = []
        
        for otherValue in otherValues {
            if V.isDuplicate(lhs: value, rhs: otherValue) {
                duplicates.append(otherValue)
            }
        }
        
        return duplicates
    }
}
