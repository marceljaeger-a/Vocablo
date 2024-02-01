//
//  DuplicationRecognitionService.swift
//  Vocablo
//
//  Created by Marcel Jäger on 30.01.24.
//

import Foundation

///Has functionality to recognize duplicatas within Arrays.
struct DuplicateRecognitionService {
    ///Returns true if there exists a duplciacte within the Array.
    ///- Parameters:
    ///     - value: The value which the methode compares with the **otherValues** if it contains duplicates.
    ///     - otherValues: The Array which the methode compares with **value** if it contains duplicates.
    ///
    ///- Returns: True if **otherValues** contains duplicates of **value.**
    func existDuplicate<V: Duplicateable>(of value: V, within otherValues: Array<V>) -> Bool {
        for otherValue in otherValues {
            if V.isDuplicate(lhs: value, rhs: otherValue) {
                return true
            }
        }
        
        return false
    }
    
    ///Returns values with duplicates within the Array.
    ///- Parameters:
    ///     - otherValues: The Array which the methode iterates and looks for duplicates.
    ///
    ///- Returns: The values of **otherValues** those have duplicates within **otherValues**.
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
    ///- Parameters:
    ///     - value: The value which the methode compares with the **otherValues** and looks for duplicates.
    ///     - otherValues: The Array which the methode compares with **value** and looks for duplicates.
    ///
    ///- Returns: The duplicates of **value** within **otherValues**.
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
