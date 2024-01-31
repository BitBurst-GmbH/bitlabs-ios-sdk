//
//  UIView+Extension.swift
//  BitLabs
//
//  Created by Omar Raad on 31.01.24.
//

import Foundation

extension UIView {
    func replaceSubView(_ subview: UIView) {
        subviews.forEach { $0.removeFromSuperview() } // Remove older subviews
        
        addSubview(subview)
    }
}
