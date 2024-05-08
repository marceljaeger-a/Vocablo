//
//  LastRepetitionDatePicker.swift
//  Vocablo
//
//  Created by Marcel Jäger on 01.03.24.
//

import Foundation
import SwiftUI
import SwiftData


//struct LastRepetitionDatePicker: View {
//    
//    //MARK: - Dependencies
//    
//    @Binding var state: LearningState
//    
//    //MARK: - Body
//
//    var body: some View {
//        if state.isNewly == false {
//            var bindedLastRepetition: Binding<Date> {
//                Binding {
//                    state.lastRepetition!
//                } set: { newDate in
//                    state.lastRepetition = newDate
//                }
//            }
//
//            DatePicker("Last repetition", selection: bindedLastRepetition)
//                .datePickerStyle(.stepperField)
//
//        }else {
//            HStack {
//                Text("Last repetition")
//
//                Spacer()
//
//                Button {
//                    state.lastRepetition = .now
//                } label: {
//                    Text("Set")
//                }
//            }
//        }
//    }
//}
