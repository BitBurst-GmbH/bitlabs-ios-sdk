//
//  TestingViewController.swift
//  BitLabs
//
//  Created by Omar Raad on 23.10.23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
@testable import BitLabs


class TestingViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    let wvc = WebViewController(nibName: String(describing: WebViewController.self), bundle: bundle)

    
    @IBAction func noURLButton(_ sender: Any) {
        wvc.modalPresentationStyle = .overFullScreen
        present(wvc, animated: true)
    }
    
    @IBAction func emptyURLButton(_ sender: Any) {
        wvc.initialURL = URL(string: "")
        
        wvc.modalPresentationStyle = .overFullScreen
        present(wvc, animated: true)
    }
    
    @IBAction func incorrectURLButton(_ sender: Any) {
        wvc.initialURL = URL(string: "Random String not a URL")
        
        wvc.modalPresentationStyle = .overFullScreen
        present(wvc, animated: true)
    }
    
    @IBAction func correctFormURLButton(_ sender: Any) {
        wvc.initialURL = URL(string: "https://www.google.com")
        
        wvc.modalPresentationStyle = .overFullScreen
        present(wvc, animated: true)
    }
    
    @IBAction func sdkCloseEventButton(_ sender: Any) {
        wvc.initialURL = URL(string: "https://www.google.com")
        
        wvc.modalPresentationStyle = .overFullScreen
        present(wvc, animated: true) {
            let sdkCloseEvent = """
            {type: 'hook', name: 'offerwall-core:sdk.close', args: []}
            """
            self.wvc.webView.evaluateJavaScript("""
            window.webkit.messageHandlers.iOSWebView.postMessage(JSON.stringify(\(sdkCloseEvent)));
            """)
        }
    }
    
    @IBAction func surveyStartEventButton(_ sender: Any) {
        wvc.initialURL = URL(string: "https://www.google.com")
        wvc.delegate = self
                
        wvc.modalPresentationStyle = .overFullScreen
        present(wvc, animated: true) {
            let surveyEvent = """
            {type: 'hook', name: 'offerwall-surveys:survey.start', args: [{clickId: 'arbitrary', link: ''}]}
            """
            self.wvc.webView.evaluateJavaScript("""
            window.webkit.messageHandlers.iOSWebView.postMessage(JSON.stringify(\(surveyEvent)));
            """)
        }
    }
}

extension TestingViewController: WebViewDelegate {
    func rewardCompleted(_ value: Double) {
    }
    
    func sendLeaveSurveyRequest(clickId: String, reason: LeaveReason, _ completion: @escaping () -> ()) {
        print("LeaveSurveyRequest")
        label.text = reason.rawValue.localized
        wvc.dismiss(animated: true)
    }
}
