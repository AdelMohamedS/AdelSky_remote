//
//  TabBarView.swift
//  AdelSky
//
//  Created by Adel The Adroit  on 14/09/2023.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Current", systemImage: "sunrise")
                }
            CityView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
