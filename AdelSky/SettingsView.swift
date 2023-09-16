//
//  SettingsView.swift
//  AdelSky
//
//  Created by Adel The Adroit  on 15/09/2023.
//

import SwiftUI

struct SettingsView: View {
    @Binding var selected: Int
    @Binding var extraDetailsSelection: Int
    
    var body: some View {
        NavigationStack {
            List {
                Picker(selection: $selected, label: Text("Temperature Units")) {
                    Text("°C").tag(1)
                    Text("°F").tag(2)
                    Text("°K").tag(3)
                }
                .pickerStyle(.navigationLink)
                
                Picker(selection: $extraDetailsSelection, label: Text("Extra Details View")) {
                    Text("Horizontal").tag(1)
                    Text("Vertical").tag(2)
                }
                .pickerStyle(.navigationLink)
            }

            .navigationTitle("Settings")
        }
    }
}
