//
//  ViewController.swift
//  BitLabs
//
//  Created by Omar Raad on 23.10.23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import BitLabs

class ViewController: UIViewController {
    override func viewDidLoad() {
        BitLabs.shared.configure(token: "afdfadsfads", uid: "fasdf")
    }
    
    @IBAction func onWebviewPressed(_ sender: Any) {
        BitLabs.shared.launchOfferWall(parent: self)
    }
}
