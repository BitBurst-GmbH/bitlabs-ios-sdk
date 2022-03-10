//
//  WebViewController.swift
//  BitLabs
//
//  Created by Omar Raad on 07/03/2022.
//

import UIKit
import WebKit

protocol WebViewDelegate {
    func onReward(_ value: Float)
    func leaveSurvey(networkId: String, surveyId: String, reason: LeaveReason, _ completion: @escaping ((Bool) -> ()))
}

class WebViewController: UIViewController {
	
	@IBOutlet weak var topBarView: UIView?
	@IBOutlet weak var closeView: UIView?
    
	@IBOutlet weak var closeBtn: UIButton?
    @IBOutlet weak var backBtn: UIButton?
    
	@IBOutlet weak var webView: WKWebView?
    @IBOutlet weak var webtTopSafeTopConstraint: NSLayoutConstraint!
    
    var uid = ""
    var token = ""
    var surveyId = ""
    var networkId = ""
    var tags: [String: Any] = [:]
    
    var bitLabsDelegate: WebViewDelegate?
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
        webView?.navigationDelegate = self

        loadOfferwall()
	}
    
	@IBAction func closeBtnPressed(_ sender: UIButton) {
		dismiss(animated: true)
	}
	
	@IBAction func backBtnPressed(_sender: UIButton) {
        let podBundle = Bundle(for: WebViewController.self)
        let leaveTitle = NSLocalizedString( "LEAVE_TITLE", bundle: podBundle, value: "", comment: "")
        let leaveDescription = NSLocalizedString( "LEAVE_DESC", bundle: podBundle, value: "", comment: "")
        
        let leaveAlertController = UIAlertController(title: leaveTitle, message: leaveDescription, preferredStyle: .alert)
        
        for reason in LeaveReason.allCases {
            let translatedTextValue = NSLocalizedString(reason.rawValue, bundle: podBundle, value: "", comment: "")
            let reasonEntry = UIAlertAction(title: translatedTextValue, style: .default) { lol in
                self.leaveSurvey(reason: reason)
            }
            leaveAlertController.addAction(reasonEntry)
        }
        
        let localizedContinue = NSLocalizedString("CONTINUE_SURVEY", bundle: podBundle, value: "", comment: "")
        let continueSurvey = UIAlertAction(title: localizedContinue, style: .cancel)
        leaveAlertController.addAction(continueSurvey)
        present(leaveAlertController, animated: true)
	}
    
    func loadOfferwall() {
        guard let url = generateURL() else {
            print("[BitLabs] Error generating URL...")
            dismiss(animated: true)
            return
        }
        
        webView?.load(URLRequest(url: url))
    }
    
    private func generateURL() -> URL? {
        
        guard var urlComponents = URLComponents(string: "https://web.bitlabs.ai") else {
            return nil
        }
        
        var queryItems = [
            URLQueryItem(name: "uid", value: uid),
            URLQueryItem(name: "token", value: token)]
        
        tags.forEach { tag in
            queryItems.append(URLQueryItem(name: tag.key, value: String(describing: tag.value)))
        }
        
        urlComponents.queryItems = queryItems
        
        return urlComponents.url
    }
    
    func leaveSurvey(reason: LeaveReason) {
        bitLabsDelegate?.leaveSurvey(networkId: networkId, surveyId: surveyId, reason: reason) { _ in
            self.loadOfferwall()
        }
        
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url?.absoluteString else {
            decisionHandler(.allow)
            return
        }
        
        if url.contains("survey/complete") || url.contains("survey/screenout") {
            bitLabsDelegate?.onReward(Float(URLComponents(string: url)?.queryItems?.first(where: {$0.name == "val"})?.value ?? "") ?? 0)
        }
        
        let isPageOfferwall = url.starts(with: "https://web.bitlabs.ai")
        
        if !isPageOfferwall, let result = getNetworkAndSurveyId(fromURL: url) {
            networkId = result.networkId
            surveyId = result.surveyId
        }
        
        configureUI(isPageOfferwall)
     
        decisionHandler(.allow)
    }
    
    private func getNetworkAndSurveyId(fromURL url: String) -> (networkId: String, surveyId: String)? {
        do {
            let regex = try NSRegularExpression(
                pattern: "\\/networks\\/(\\d+)\\/surveys\\/(\\d+)",
                options: .caseInsensitive)
            let matches = regex.matches(
                in: url,
                options: .withTransparentBounds,
                range: NSMakeRange(0, url.count))
            
            if matches.isEmpty { return nil }
            
            guard let url = URL(string: url) else { throw NSError() }
            
            let components = url.pathComponents
            
            guard let network = components.firstIndex(of: "networks"), let survey = components.firstIndex(of: "surveys") else { throw NSError() }
            
            return (components[network+1], components[survey+1])
        } catch(let error) {
            print("[BitLabs] Error Extracting NetworkId and SurveyId:  \(error)")
            return nil
        }
    }
    
    private func configureUI(_ isPageOfferwall: Bool) {
        UIView.animate(withDuration: 1) {
            if isPageOfferwall {
                self.topBarView?.isHidden = true
                self.closeView?.isHidden = false
                self.webtTopSafeTopConstraint.constant = 0
            } else {
                self.topBarView?.isHidden = false
                self.closeView?.isHidden = true
                self.webtTopSafeTopConstraint.constant = self.topBarView?.frame.height ?? 0
            }
        }
    }
}
