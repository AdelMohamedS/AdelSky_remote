//
//  TabBarView.swift
//  AdelSky
//
//  Created by Adel The Adroit  on 15/09/2023.
//

import SwiftUI

struct TabBarView: View {
    @AppStorage ("key") var selected: Int = 1
    @AppStorage ("key2") var extraDetailsSelection: Int = 1
    @AppStorage ("key3") var searchHistory: [String] = []
    @State var searchTerm: String = ""
    @State var weatherData: WeatherData?
    var body: some View {
        TabView {
            CurrentWeatherView(weatherData: $weatherData, selected: $selected, extraDetailsSelection: $extraDetailsSelection)
                .tabItem {
                    Label("Current", systemImage: "location")
                }
            SearchWeatherView(searchTerm: $searchTerm, selected: $selected, extraDetailsSelection: $extraDetailsSelection, searchHistory: $searchHistory)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            SettingsView(selected: $selected, extraDetailsSelection: $extraDetailsSelection, searchHistory: $searchHistory)
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
