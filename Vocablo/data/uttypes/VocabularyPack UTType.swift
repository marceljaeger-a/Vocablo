//
//  VocabularyPack.swift
//  Vocablo
//
//  Created by Marcel Jäger on 14.11.23.
//

import Foundation
import UniformTypeIdentifiers

extension UTType {
    
    ///Returns the UTType for the Vocablo FileDocument package.
    static var vocablo: UTType {
        UTType(exportedAs: "com.marceljaeger.vocablo.vocabularypack")
    }
}
