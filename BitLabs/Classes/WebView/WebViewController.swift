//
//  WebViewController.swift
//  BitLabs
//
//  Created by Omar Raad on 07/03/2022.
//

import UIKit
import WebKit

/// This delegate is to help a class execute some functions to which it doesn't have access
protocol WebViewDelegate {
    /// The completion handler that will execute immediately after the user is rewarded.
    ///  - Parameter value: The amount of the reward.
    func rewardCompleted(_ value: Float)
    
    /// Sends the leave reason to the BitLabs API
    ///
    /// - Parameters:
    ///  - networkId: The ID of the network of the survey.
    ///  - surveyId: The ID of the survey.
    ///  - reason: The reason the user left the survey.
    ///  - completion: The completion closure to execute after the leave request is executed.
    ///
    /// - Tag: sendLeaveSurveyRequest
    func sendLeaveSurveyRequest(networkId: String, surveyId: String, reason: LeaveReason, _ completion: @escaping ((Bool) -> ()))
}

class WebViewController: UIViewController {
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var closeView: UIView!

    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var webtTopSafeTopConstraint: NSLayoutConstraint!
    
    var uid = ""
    var token = ""
    var surveyId = ""
    var networkId = ""
    var tags: [String: Any] = [:]
    var reward: Float = 0.0
    var delegate: WebViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        loadOfferwall()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        }
        super.viewDidDisappear(animated)
        delegate?.rewardCompleted(reward)
    }
    
    @IBAction func closeBtnPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func backBtnPressed(_sender: UIButton) {
        let leaveAlertController = UIAlertController(
            title: Localized.leaveTitle,
            message: Localized.leaveDescription,
            preferredStyle: .alert)
        
        for reason in LeaveReason.allCases {
            let reasonEntry = UIAlertAction(title: reason.rawValue.localized, style: .default) { _ in
                self.sendLeaveRequest(reason: reason)
            }
            leaveAlertController.addAction(reasonEntry)
        }
        
        leaveAlertController.addAction(UIAlertAction(title: Localized.continueSurvey, style: .cancel))
        present(leaveAlertController, animated: true)
    }
    
    /// Calls [generateURL()](x-source-tag://generateURL) and loads it into the WebView
    private func loadOfferwall() {
        guard let url = generateURL() else {
            print("[BitLabs] Error generating URL...")
            dismiss(animated: true)
            return
        }
        
        webView?.load(URLRequest(url: url))
    }
    
    /// Generates the URL the BitLabs Offerwall
    /// - Tag: generateURL
    /// - Returns: The generated URL
    private func generateURL() -> URL? {
        guard var urlComponents = URLComponents(string: "https://web.bitlabs.ai") else { return nil }
        
        var queryItems = [
            URLQueryItem(name: "uid", value: uid),
            URLQueryItem(name: "token", value: token)]
        
        tags.forEach { tag in
            queryItems.append(URLQueryItem(name: tag.key, value: String(describing: tag.value)))
        }
        
        urlComponents.queryItems = queryItems
        
        return urlComponents.url
    }
    
    /// Invokes the [sendLeaveSurveyRequest](x-source-tag://sendLeaveSurveyRequest).
    /// - Parameter reason: The reason to be sent. Check [LeaveReason](x-source-tag://LeaveReason).
    private func sendLeaveRequest(reason: LeaveReason) {
        delegate?.sendLeaveSurveyRequest(networkId: networkId, surveyId: surveyId, reason: reason) { _ in
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
            reward += Float(URLComponents(string: url)?.queryItems?.first(where: {$0.name == "val"})?.value ?? "") ?? 0
        }
        
        let isPageOfferwall = url.starts(with: "https://web.bitlabs.ai")
        
        if !isPageOfferwall, let result = getNetworkAndSurveyId(fromURL: url) {
            networkId = result.networkId
            surveyId = result.surveyId
        }
        
        configureUI(isPageOfferwall)
        
        decisionHandler(.allow)
    }
    
    
    /// Extracts the Network ID and Survey ID for the current Survey and User.
    ///
    /// It checks whether the URL has the `networks` and `surveys` endpoints. If it has, it exctracts both IDs from it.
    /// - Parameter url: The URL from which the IDs should be extracted.
    /// - Returns: The `networkId` and `surveyId`extracted from `url`. It return nil in case the `url` doesn't have the IDs.
    private func getNetworkAndSurveyId(fromURL url: String) -> (networkId: String, surveyId: String)? {
        do {
            let regex = try NSRegularExpression(pattern: "\\/networks\\/(\\d+)\\/surveys\\/(\\d+)", options: .caseInsensitive)
            let matches = regex.matches(in: url, options: .withTransparentBounds, range: NSMakeRange(0, url.count))
            
            if matches.isEmpty { return nil }
            
            guard let url = URL(string: url) else { throw NSError() }
            
            let components = url.pathComponents
            
            guard let network = components.firstIndex(of: "networks"), let survey = components.firstIndex(of: "surveys") else { throw NSError() }
            
            return (components[network+1], components[survey+1])
        } catch(let error) {
            print("[BitLabs] Error Extracting NetworkId and SurveyId. Reference: \(error)")
            return nil
        }
    }
    
    /// Applies UI changes according to the data it has.
    ///
    /// If the page is the Offerwall, the `topBarView` will be hidden. Otherwise, it will be visible.
    /// - Parameter isPageOfferwall: The bool to determine whether the current page is the Offerwall.
    private func configureUI(_ isPageOfferwall: Bool) {
        topBarView.isHidden = isPageOfferwall
        closeView.isHidden = !isPageOfferwall
        webtTopSafeTopConstraint.constant = isPageOfferwall ? 0:topBarView.frame.height
    }
}
