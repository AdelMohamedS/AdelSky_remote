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
    @Binding var searchHistory: [String]
    @Binding var selectedLanguage: Int
    
    var body: some View {
        NavigationStack {
            List {
                Picker(selection: $selected, label: Text("Temperature Units".localized())) {
                    Text("°C").tag(1)
                    Text("°F").tag(2)
                    Text("°K").tag(3)
                }
                .pickerStyle(.navigationLink)
                
                Picker(selection: $extraDetailsSelection, label: Text("Extra Details View".localized())) {
                    Text("Horizontal".localized()).tag(1)
                    Text("Vertical".localized()).tag(2)
                }
                .pickerStyle(.navigationLink)
                
                .pickerStyle(.navigationLink)
                
                Section {
                    Button("Clear Search History".localized()) {
                        clearArray(&searchHistory)
                    }
                }
            }

            .navigationTitle("Settings".localized())
        }
    }
}

func clearArray(_ array: inout [String]) {
    array = []
}

extension Array: RawRepresentable where Element: Codable {
 public init? (rawValue: String) {
  guard let data = rawValue.data (using: .utf8),
  let result = try? JSONDecoder ().decode ( [Element].self, from: data)
  else {
   return nil
  }
  self = result
 }

 public var rawValue: String {
  guard let data = try? JSONEncoder ().encode (self),
  let result = String (data: data, encoding: .utf8)
  else {
   return "[]"
  }
  return result
 }
}
