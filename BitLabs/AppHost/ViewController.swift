//
//  ViewController.swift
//  BitLabs
//
//  Created by Omar Raad on 23.10.23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
@testable import BitLabs

class ViewController: UIViewController {
    override func viewDidLoad() {
        BitLabs.shared.configure(token: "678c564f-62a3-4331-a018-0bf7ee2c885b", uid: "fasdf")
    }
    
    @IBAction func noURLButton(_ sender: Any) {
        let wv = WebViewController(nibName: String(describing: WebViewController.self), bundle: bundle)
        
        wv.modalPresentationStyle = .overFullScreen
        present(wv, animated: true)
    }
    
    @IBAction func emptyURLButton(_ sender: Any) {
        let wv = WebViewController(nibName: String(describing: WebViewController.self), bundle: bundle)
        
        wv.url = URL(string: "")
        
        wv.modalPresentationStyle = .overFullScreen
        present(wv, animated: true)
    }
    
    @IBAction func incorrectURLButton(_ sender: Any) {
        let wv = WebViewController(nibName: String(describing: WebViewController.self), bundle: bundle)
        
        wv.url = URL(string: "Random String not a URL")
        
        wv.modalPresentationStyle = .overFullScreen
        present(wv, animated: true)
    }
    
    @IBAction func correctFormURLButton(_ sender: Any) {
        let wv = WebViewController(nibName: String(describing: WebViewController.self), bundle: bundle)
        
        wv.url = URL(string: "https://www.google.com")
        
        wv.modalPresentationStyle = .overFullScreen
        present(wv, animated: true)
    }
}
