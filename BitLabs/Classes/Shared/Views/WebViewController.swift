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
    ///  - Parameter clickId: The click ID of the survey.
    ///  - Parameter reason: The reason the user left the survey.
    ///  - Parameter completion: The completion closure to execute after the leave request is executed.
    ///
    /// - Tag: sendLeaveSurveyRequest
    func sendLeaveSurveyRequest(clickId: String, reason: LeaveReason, _ completion: @escaping () -> ())
}

class WebViewController: UIViewController {
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var webTopSafeTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorView: UIStackView!
    
    var uid = ""
    var sdk = ""
    var adId = ""
    var token = ""
    var clickId = ""
    var shouldOpenExternally = false
    var color: [UIColor] = [.black, .black]
    var tags: [String: Any] = [:]
    
    var delegate: WebViewDelegate?
    var observer: NSKeyValueObservation?
    
    private var reward: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var isColorBright = false
        
        color.forEach { isColorBright = isColorBright || $0.luminance > 0.729 }
        
        setupWebView()
        
        changeGradient(of: topBarView, withColors: color)
        
        backButton.tintColor = isColorBright ? .black : .white
        
        loadOfferwall()
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.rewardCompleted(reward)
    }
    
    private func setupWebView() {
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        observer = webView.observe(\.url, options: .new) { [self] webview, change in
            guard let newValue = change.newValue, let url = newValue else { return }
            
            if url.absoluteString.hasSuffix("/close") {
                dismiss(animated: true)
                return
            }
            
            if self.shouldOpenExternally, UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                print("[BitLabs] Redirected to browser. It includes Offers.")
                self.dismiss(animated: true)
                return
            }
            
            let urlStr = url.absoluteString
            
            let isPageOfferwall = urlStr.starts(with: "https://web.bitlabs.ai")
            
            if isPageOfferwall {
                if urlStr.contains("/survey-complete") || urlStr.contains("/survey-screenout") || urlStr.contains("/start-bonus") {
                    reward += Float(URLComponents(string: urlStr)?.queryItems?.first {$0.name == "val"}?.value ?? "") ?? 0
                }
            } else {
                clickId = URLComponents(string: urlStr)?.queryItems?.first { $0.name == "clk" }?.value ?? clickId
            }
            
            configureUI(isPageOfferwall)
        }
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
        delegate?.sendLeaveSurveyRequest(clickId: clickId, reason: reason) {
            self.errorView.isHidden = true
            self.clickId = ""
            self.loadOfferwall()
        }
    }
    
    /// Applies UI changes according to the data it has.
    ///
    /// If the page is the Offerwall, the `topBarView` will be hidden. Otherwise, it will be visible.
    private func configureUI(_ isPageOfferwall: Bool) {
        topBarView.isHidden = isPageOfferwall
        webTopSafeTopConstraint.constant = isPageOfferwall ? 0 : topBarView.frame.height
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        presentFail()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        presentFail()
    }
    
    func presentFail() {
        errorView.isHidden = false
        
        let errorStr = "{ uid: \(uid), date: \(Int(Date().timeIntervalSince1970)) }"
        let error = Data(errorStr.utf8).base64EncodedString()
        
        if let imageView = errorView.subviews.first as? UIImageView {
            imageView.image = generateQRCode(from: error)
        }
        
        if let label = errorView.subviews.last as? UILabel {
            label.text = "Error ID: \(error)"
        }
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
