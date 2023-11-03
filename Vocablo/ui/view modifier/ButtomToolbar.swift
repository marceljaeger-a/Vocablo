//
//  ButtomToolbar.swift
//  Vocablo
//
//  Created by Marcel Jäger on 03.11.23.
//

import Foundation
import SwiftUI

extension List {
    func buttomToolbar(leftButton: () -> some View, rightButton: () -> some View) -> some View {
        self.overlay {
            ZStack(alignment: .topLeading){
                Color.gray.opacity(0)
                
                VStack {
                    Spacer()
                        
                    HStack{
                        leftButton()
                        
                        Spacer()
                        
                        rightButton()
                    }
                    .padding(8)
                    .background(.thickMaterial, in: .containerRelative)
                }
            }
        }
    }
}
