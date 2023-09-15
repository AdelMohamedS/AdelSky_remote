//
//  SettingsView.swift
//  AdelSky
//
//  Created by Adel The Adroit  on 15/09/2023.
//

import SwiftUI

struct SettingsView: View {
    @Binding var selectedOption: Int
    @Binding var currentUnit: Double
    @Binding var currentUnitSymbol: String
    
    func updateCurrentUnit() {
        switch selectedOption {
        case 1: currentUnit = 273.15
        case 2: currentUnit = 255.372
        case 3: currentUnit = 0.0
        default: currentUnit = 273.15
        }
    }
    func updateCurrentUnitSymbol() {
        switch selectedOption {
        case 1: currentUnitSymbol = "C"
        case 2: currentUnitSymbol = "F"
        case 3: currentUnitSymbol = "K"
        default: currentUnitSymbol = "C"
        }
    }
    
    var body: some View {
        NavigationStack {
            Picker(selection: $selectedOption, label: Text("Temperature Units")) {
                Text("°C").tag(1)
                Text("°F").tag(2)
                Text("°K").tag(3)
            }
            .onChange(of: selectedOption, perform: { _ in
                updateCurrentUnit()
                updateCurrentUnitSymbol()
            })
            .padding()
            .pickerStyle(.navigationLink)
            
            .navigationTitle("Settings")
        }
    }
}
