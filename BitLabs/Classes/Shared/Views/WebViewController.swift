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
    
    var url: URL?
    
    var uid = ""
    var sdk = ""
    var adId = ""
    var token = ""
    var tags: [String: Any] = [:]
    var color: [UIColor] = [.black, .black]
    
    var clickId = ""
    var areParametersInjected = true
    
    var delegate: WebViewDelegate?
    var observer: NSKeyValueObservation?
    
    private var didCallViewDidAppear = false
    
    private var reward: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var isColorBright = false
        backButton.tintColor = isColorBright ? .black : .white
        color.forEach { isColorBright = isColorBright || $0.luminance > 0.729 }
        
        changeGradient(of: topBarView, withColors: color)
        
        setupWebView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if didCallViewDidAppear {
            return
        }
        
        loadOfferwall()
        didCallViewDidAppear = true
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
        webView.scrollView.bounces = false
        observer = webView.observe(\.url, options: .new) { [self] webview, change in
            guard let newValue = change.newValue, let url = newValue else { return }
            
//            if url.absoluteString.hasSuffix("/close") {
//                dismiss(animated: true)
//                return
//            }
            
            let urlStr = url.absoluteString
            
            let isPageOfferwall = urlStr.starts(with: "https://web.bitlabs.ai")
            
            if isPageOfferwall {
                if !areParametersInjected, !urlStr.contains("sdk=\(sdk)"), let url = generateURL(urlStr) {
                    webview.load(URLRequest(url: url))
                    areParametersInjected = true
                }
            } else {
                areParametersInjected = false
            }
            
            configureUI(isPageOfferwall)
        }
        
        configurePostMessageAPI()
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
        if let url = url {
            webView?.load(URLRequest(url: url))
            return
        }
        
        print("[BitLabs] Error generating URL...")
        dismiss(animated: true)
    }
    
    /// Generates the URL the BitLabs Offerwall
    /// - Tag: generateURL
    private func generateURL(_ url: String) -> URL? {
        guard var urlComponents = URLComponents(string: url) else { return nil }
        
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
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let js = """
            window.addEventListener('message', function(event) {
                window.webkit.messageHandlers.iOSWebView.postMessage(JSON.stringify(event.data));
            });
        """
        
        self.webView.evaluateJavaScript(js)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        presentFail()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        presentFail()
    }
    
    func presentFail() {
        guard (BitLabs.shared.isDebugMode) else {
            return
        }
        
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

extension WebViewController: WKScriptMessageHandler {
    func configurePostMessageAPI() {
        webView.configuration.userContentController.add(self, name: "iOSWebView")
        
        let js = """
            window.parent.postMessage('Message sent from iOS');
            window.postMessage({ target: 'app.visual.dark.background_color', value: '#FF0000' }, '*');
        """

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.webView.evaluateJavaScript(js)
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("[BitLabs]", message.body)
        
        guard let hookMessage = (message.body as! String).asHookMessage() else {
            return
        }
        
        print(hookMessage)
        
        switch hookMessage.name {
        case .sdkClose:
            dismiss(animated: true)
        case .initOfferwall:
            print("INIT OFFERWALL")
        case .surveyComplete:
            print("SURVEY COMPLETE")
        case .surveyScreentout:
            print("SURVEY SCREENOUT")
        case .surveyStartBonus:
            print("SURVEY START BONUS")
        case .surveyStart:
            print("SURVEY START")
        }
    }
}
