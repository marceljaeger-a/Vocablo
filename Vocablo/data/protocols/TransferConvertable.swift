//
//  TransferTypeable.swift
//  Vocablo
//
//  Created by Marcel Jäger on 29.11.23.
//

import Foundation
import SwiftUI

protocol TransferConvertable {
    associatedtype Transfer = TransferType
    init(from value: Transfer)
    func convert() -> Transfer
}

protocol TransferType: Codable, Transferable {
    
}





