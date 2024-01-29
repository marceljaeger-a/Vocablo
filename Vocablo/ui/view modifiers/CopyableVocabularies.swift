//
//  CopyableVocabularies.swift
//  Vocablo
//
//  Created by Marcel Jäger on 07.12.23.
//

import Foundation
import SwiftUI

extension View {
    func copyableVocabularies(_ vocabularies: Array<Vocabulary>) -> some View {
        return self.copyable(vocabularies.map{ $0.convert() })
    }
}
