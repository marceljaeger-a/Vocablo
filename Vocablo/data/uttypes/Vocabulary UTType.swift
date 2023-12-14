//
//  Vocabulary.swift
//  Vocablo
//
//  Created by Marcel Jäger on 15.11.23.
//

import Foundation
import UniformTypeIdentifiers

extension UTType {
    static var vocabulary: UTType {
        UTType(exportedAs: "com.marceljaeger.vocabulary")
    }
}
