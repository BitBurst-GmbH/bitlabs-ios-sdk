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
    ///  - Parameter networkId: The ID of the network of the survey.
    ///  - Parameter surveyId: The ID of the survey.
    ///  - Parameter reason: The reason the user left the survey.
    ///  - Parameter completion: The completion closure to execute after the leave request is executed.
    ///
    /// - Tag: sendLeaveSurveyRequest
    func sendLeaveSurveyRequest(networkId: String, surveyId: String, reason: LeaveReason, _ completion: @escaping () -> ())
}

class WebViewController: UIViewController {
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var webTopSafeTopConstraint: NSLayoutConstraint!
    
    var uid = ""
    var sdk = ""
    var adId = ""
    var token = ""
    var surveyId = ""
    var networkId = ""
    var hasOffers = false
    var tags: [String: Any] = [:]
    
    var delegate: WebViewDelegate?
    
    private var reward: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        
        loadOfferwall()
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
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
        if let url = generateURL() {
            webView?.load(URLRequest(url: url))
            return
        }
        
        print("[BitLabs] Error generating URL...")
        dismiss(animated: true)
    }
    
    /// Generates the URL the BitLabs Offerwall
    /// - Tag: generateURL
    /// - Returns: The generated URL
    private func generateURL() -> URL? {
        guard var urlComponents = URLComponents(string: "https://web.bitlabs.ai") else { return nil }
        
        var queryItems = [
            URLQueryItem(name: "uid", value: uid),
            URLQueryItem(name: "token", value: token),
            URLQueryItem(name: "os", value: "IOS"),
            URLQueryItem(name: "sdk", value: sdk)]
        
        if !adId.isEmpty {
            queryItems.append(URLQueryItem(name: "maid", value: adId))
        }
        
        tags.forEach { tag in
            queryItems.append(URLQueryItem(name: tag.key, value: String(describing: tag.value)))
        }
        
        urlComponents.queryItems = queryItems
        
        return urlComponents.url
    }
    
    /// Invokes the [sendLeaveSurveyRequest](x-source-tag://sendLeaveSurveyRequest).
    /// - Parameter reason: The reason to be sent. Check [LeaveReason](x-source-tag://LeaveReason).
    private func sendLeaveRequest(reason: LeaveReason) {
        delegate?.sendLeaveSurveyRequest(networkId: networkId, surveyId: surveyId, reason: reason) {
            self.networkId = ""
            self.surveyId = ""
            self.loadOfferwall()
        }
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
//        if hasOffers, UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url)
//            print("[BitLabs] Redirected to browser. No need to open it locally")
//            decisionHandler(.cancel)
//            dismiss(animated: true)
//            return
//        }
        
        let urlStr = url.absoluteString
        
        if urlStr.contains("survey/complete") || urlStr.contains("survey/screenout") {
            reward += Float(URLComponents(string: urlStr)?.queryItems?.first(where: {$0.name == "val"})?.value ?? "") ?? 0
        }
        
        let isPageOfferwall = urlStr.starts(with: "https://web.bitlabs.ai")
        
        if !isPageOfferwall {
            getNetworkAndSurveyId(fromURL: urlStr)
        }
        
        configureUI(isPageOfferwall)
        
        decisionHandler(.allow)
    }
    
    
    /// Extracts the Network ID and Survey ID for the current Survey and User.
    ///
    /// It checks whether the URL has the `networks` and `surveys` endpoints. If it has, it exctracts both IDs from it.
    /// - Parameter url: The URL from which the IDs should be extracted.
    /// - Returns: The `networkId` and `surveyId`extracted from `url`. It return nil in case the `url` doesn't have the IDs.
    private func getNetworkAndSurveyId(fromURL url: String) {
        guard networkId.isEmpty, surveyId.isEmpty else { return }
        
        do {
            let regex = try NSRegularExpression(pattern: "\\/networks\\/(\\d+)\\/surveys\\/(\\d+)", options: .caseInsensitive)
            let matches = regex.matches(in: url, options: .withTransparentBounds, range: NSMakeRange(0, url.count))
            
            if matches.isEmpty { return }
            
            guard let url = URL(string: url) else { throw NSError() }
            
            let components = url.pathComponents
            
            guard let network = components.firstIndex(of: "networks"),
                  let survey = components.firstIndex(of: "surveys")
            else { throw NSError() }
            
            networkId = components[network+1]
            surveyId = components[survey+1]
        } catch(let error) {
            print("[BitLabs] Error Extracting NetworkId and SurveyId. Reference: \(error)")
        }
    }
    
    /// Applies UI changes according to the data it has.
    ///
    /// If the page is the Offerwall, the `topBarView` will be hidden. Otherwise, it will be visible.
    /// - Parameter isPageOfferwall: The bool to determine whether the current page is the Offerwall.
    private func configureUI(_ isPageOfferwall: Bool) {
        topBarView.isHidden = isPageOfferwall
        closeButton.isHidden = !isPageOfferwall
        webTopSafeTopConstraint.constant = isPageOfferwall ? 0 : topBarView.frame.height
    }
}

extension WebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil, let url = navigationAction.request.url {
            UIApplication.shared.open(url)
        }
        return nil
    }
}
