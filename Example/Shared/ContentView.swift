//
//  ContentView.swift
//  Shared
//
//  Copyright © 2022 Wataku-City. All rights reserved.
//

import SwiftUI
import WheelPicker

struct ContentView: View {
    @State private var finitePickerSelection = 90
    @State private var circularPickerSelection = 90
    @State private var datePickerSelection = Date()
    private let items = (0...180).map { $0 }
    
    private func text(from value: Int?) -> String {
        guard let value = value else { return "" }
        return String(value)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Selected: \(finitePickerSelection)")
                    .frame(maxWidth: .infinity)
                    .padding(8)
                
                Text("Selected: \(circularPickerSelection)")
                    .frame(maxWidth: .infinity)
                    .padding(8)
            }
            
            HStack {
                FiniteWheelPicker(selection: $finitePickerSelection, items: items) {
                    Text(text(from: $0))
                }
                .frame(maxWidth: .infinity)
                
                CircularWheelPicker(selection: $circularPickerSelection, items: items) {
                    Text(text(from: $0))
                }
                .frame(maxWidth: .infinity)
            }
            
            HStack {
                Button(action: { finitePickerSelection = 90 }) {
                    Text("Reset")
                }
                .frame(maxWidth: .infinity)
                
                Button(action: { circularPickerSelection = 90 }) {
                    Text("Reset")
                }
                .frame(maxWidth: .infinity)
            }
            
            Divider()
            
            Text("\(datePickerSelection)")
                .padding()
            
            DateWheelPicker(selection: $datePickerSelection) { date in
                let components = Calendar.current.dateComponents([.weekday], from: date)
                switch components.weekday {
                case 1: return .red
                case 7: return .blue
                default: return nil
                }
            }
            
            Button(action: { datePickerSelection = Date() }) {
                Text("Set the current time")
            }
            .padding()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
