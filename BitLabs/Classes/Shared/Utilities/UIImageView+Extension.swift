//
//  UIImageView+Extension.swift
//  BitLabs
//
//  Created by Omar Raad on 18.02.23.
//

import Foundation

extension UIImageView {
    func setImageColor(color: UIColor) {
        let template = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = template
        self.tintColor = color
    }
}
