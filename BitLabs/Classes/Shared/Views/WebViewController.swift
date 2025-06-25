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
    func offerwallClosed(_ totalReward: Double)
    
    func rewardEarned(_ reward: Double)
    
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
    
    var initialURL: URL?
    
    var uid = "" // Recorded for error tracking in debug mode
    var color: [UIColor] = [.black, .black]
    
    var clickId = ""
    
    var delegate: WebViewDelegate?
    
    private var isRotatable: Bool = false
    private var didCallViewDidAppear = false
    
    private var totalReward: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var isColorBright = false
        backButton.tintColor = isColorBright ? .black : .white
        color.forEach { isColorBright = isColorBright || $0.luminance > 0.729 }
        
        setupWebView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if didCallViewDidAppear {
            return
        }
        
        loadOfferwall()
        didCallViewDidAppear = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DispatchQueue.main.async { changeGradient(of: self.topBarView, withColors: self.color) }
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override var shouldAutorotate: Bool {
        return isRotatable
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return isRotatable ? .all : .portrait
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.offerwallClosed(totalReward)
    }
    
    private func setupWebView() {
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.bounces = false
        
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
        if let url = initialURL {
            webView?.load(URLRequest(url: url))
            return
        }
        
        print("[BitLabs] Error generating URL...")
        dismiss(animated: true)
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
    private func configureUI(isPageSurvey: Bool) {
        topBarView.isHidden = !isPageSurvey
        webTopSafeTopConstraint.constant = isPageSurvey ? topBarView.frame.height : 0
        isRotatable = isPageSurvey
        UIDevice.current.setValue(UIInterfaceOrientation.unknown.rawValue, forKey: "orientation") // Reset orientation
        UIViewController.attemptRotationToDeviceOrientation()
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
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let hookMessage = (message.body as! String).asHookMessage() else {
            return
        }
        
        switch hookMessage.name {
        case .sdkClose:
            dismiss(animated: true)
        case .initOfferwall:
            self.webView.evaluateJavaScript("window.parent.postMessage({ target: 'app.behaviour.close_button_visible', value: true });")
            print("[BitLabs] Sent showCloseButton event")
            configureUI(isPageSurvey: true)
        case .surveyComplete:
            guard case .reward(let rewardArg) = hookMessage.args.first else {
                return
            }
            
            delegate?.rewardEarned(rewardArg.reward)
            totalReward += rewardArg.reward
        case .surveyScreentout:
            guard case .reward(let rewardArg) = hookMessage.args.first else {
                return
            }
            
            delegate?.rewardEarned(rewardArg.reward)
            totalReward += rewardArg.reward
        case .surveyStartBonus:
            guard case .reward(let rewardArg) = hookMessage.args.first else {
                return
            }
            
            delegate?.rewardEarned(rewardArg.reward)
            totalReward += rewardArg.reward
        case .surveyStart:
            configureUI(isPageSurvey: true)
            guard case .surveyStart(let surveyStartArgument) = hookMessage.args.first else {
                return
            }
            
            clickId = surveyStartArgument.clickId
        default:
            break
        }
    }
}
