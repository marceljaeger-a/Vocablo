//
//  Schema1.swift
//  Vocablo
//
//  Created by Marcel Jäger on 23.12.23.
//

import Foundation
import SwiftData

enum SchemaV1: VersionedSchema {
    static var models: [any PersistentModel.Type] {
        []
    }
    
    static var versionIdentifier: Schema.Version = .init(1, 0, 0)
}
