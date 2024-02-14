//
//  UIView+Extension.swift
//  BitLabs
//
//  Created by Omar Raad on 31.01.24.
//

import Foundation

extension UIView {
    var parentViewController: UIViewController? {
        var parent = next
        while parent != nil {
            if let vc = parent as? UIViewController {
                return vc
            }
            parent = parent?.next
        }
        return nil
    }
    
    func replaceSubView(_ subview: UIView) {
        subviews.forEach { $0.removeFromSuperview() } // Remove older subviews
        
        addSubview(subview)
    }
}
