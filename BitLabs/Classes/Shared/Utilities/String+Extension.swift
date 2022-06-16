//
//  String+Extension.swift
//  BitLabs
//
//  Created by Omar Raad on 16.06.22.
//

import Foundation

extension String {
    var localized: String {
        return bundle.localizedString(forKey: self, value: nil, table: nil)
    }
}
