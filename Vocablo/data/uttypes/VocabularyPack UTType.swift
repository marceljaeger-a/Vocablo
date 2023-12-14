//
//  VocabularyPack.swift
//  Vocablo
//
//  Created by Marcel Jäger on 14.11.23.
//

import Foundation
import UniformTypeIdentifiers

extension UTType {
    static var vocablo: UTType {
        UTType(exportedAs: "com.marceljaeger.vocablo.vocabularypack")
    }
}
