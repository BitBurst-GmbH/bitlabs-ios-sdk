//
//  ViewController.swift
//  BitLabs
//
//  Created by Omar Raad on 23.10.23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
@testable import BitLabs


class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    let wv = WebViewController(nibName: String(describing: WebViewController.self), bundle: bundle)

    
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
    
    @IBAction func offerwalURLButton(_ sender: Any) {
        let wv = WebViewController(nibName: String(describing: WebViewController.self), bundle: bundle)
        
        wv.url = URL(string: "https://web.bitlabs.ai?token=678c564f-62a3-4331-a018-0bf7ee2c885b&uid=fasdf")
        
        wv.modalPresentationStyle = .overFullScreen
        present(wv, animated: true)
    }
    
    @IBAction func notOfferwallURLButton(_ sender: Any) {
        wv.url = URL(string: "https://www.google.com")
        wv.delegate = self
        
        wv.modalPresentationStyle = .overFullScreen
        present(wv, animated: true)
    }
}

extension ViewController: WebViewDelegate {
    func rewardCompleted(_ value: Float) {
    }
    
    func sendLeaveSurveyRequest(clickId: String, reason: LeaveReason, _ completion: @escaping () -> ()) {
        print("LeaveSurveyRequest")
        label.text = reason.rawValue.localized
        wv.dismiss(animated: true)
    }
}
