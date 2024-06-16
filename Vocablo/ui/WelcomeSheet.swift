//
//  WelcomeSheet.swift
//  Vocablo
//
//  Created by Marcel Jäger on 14.12.23.
//

import Foundation
import SwiftUI

struct WelcomeSheet: View {
    
    //MARK: - Properties
    
    @Binding var isShowing: Bool
    
    //MARK: - Body
    
    var body: some View {
        VStack(spacing: 50){
            headerView
            
            featuresView
            
            continueButton
        }
        .padding(25)
    }
}



//MARK: - Subviews

extension WelcomeSheet {
    var headerView: some View {
        VStack(spacing: 15){
            Image(.appIcon)
                .resizable()
                .frame(width: 64, height: 64)
            
            VStack(spacing: 10){
                Text("Welcome to Vocablo")
                    .font(.largeTitle)
                    .fontDesign(.default)
                
                Text("Version ?.?.?")
                    .font(.title3)
                    .fontDesign(.default)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    var featuresView: some View {
        Grid(alignment: .leading, verticalSpacing: 25){
            GridRow {
                Color.accentColor.frame(width: 64, height: 64).mask {
                    Image(systemName: "list.bullet.rectangle.portrait")
                        .symbolVariant(.fill)
                        .font(.largeTitle)
                }
                
                VStack(alignment: .leading){
                    Text("Add lists with vocabularies")
                        .font(.title3)
                        .bold()
                    
                    Text("Create lists and add vocabularies. Configure the vocabularies.")
                        .foregroundStyle(.secondary)
                }
            }

            GridRow{
                Color.accentColor.frame(width: 64, height: 64).mask {
                    Image(systemName: "graduationcap")
                        .symbolVariant(.fill)
                        .font(.largeTitle)
                }
                
                VStack(alignment: .leading){
                    Text("Learn vocabularies")
                        .font(.title3)
                        .bold()
                    
                    Text("Learn with spaced repetition algorythm.")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    
    var continueButton: some View {
        Button {
            isShowing = false
        } label: {
            Text("Continue")
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.extraLarge)
    }
}
