//
//  AppVersionManager.swift
//  Vocablo
//
//  Created by Marcel Jäger on 22.12.23.
//

import Foundation
import SwiftUI
import SwiftData

struct AppVersionManager {
    static var currentVersion: String? {
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        
        return appVersion 
    }
}
