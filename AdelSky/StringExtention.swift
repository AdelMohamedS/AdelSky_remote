//
//  StringExtention.swift
//  AdelSky
//
//  Created by Adel The Adroit  on 18/09/2023.
//

import Foundation

extension String {
    func localized() -> String {
        NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
