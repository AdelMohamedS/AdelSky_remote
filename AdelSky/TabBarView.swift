//
//  TabBarView.swift
//  AdelSky
//
//  Created by Adel The Adroit  on 15/09/2023.
//

import SwiftUI

struct TabBarView: View {
    @State var selectedOption: Int = 1
    @State var currentUnit: Double = 273.15
    @State var currentUnitSymbol: String = "C"
    @State var searchTerm: String = ""
    var body: some View {
        TabView {
            CurrentWeatherView(currentUnit: $currentUnit, currentUnitSymbol: $currentUnitSymbol)
                .tabItem {
                    Label("Current", systemImage: "location")
                }
            SearchWeatherView(searchTerm: $searchTerm, currentUnit: $currentUnit, currentUnitSymbol: $currentUnitSymbol)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            SettingsView(selectedOption: $selectedOption, currentUnit: $currentUnit, currentUnitSymbol: $currentUnitSymbol)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
