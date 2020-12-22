//
//  BrowserDelegate.swift
//  BitLabSDK
//
//  Created by Frank Marx on 20.11.20.
//

import UIKit
//import Regex
import SafariServices
import WebKit

@objc
protocol WebViewControllerDelegate {
    @objc optional func handleCloseAction( _ webViewController: WebViewController)
    @objc optional func handleNavigateBackAction( _ webViewController: WebViewController)
}

public class BrowserDelegate: NSObject {
    
    public enum Constants {
        public static let baseURL = "https://web.bitlabs.ai"
        public static let apiTokenHeader = "X-Api-Token"
        public static let userIdHeader = "X-User-Id"
        public static let urlStartsWith = "web.bitlabs.ai"
        
       
    }
    
    let exampleURL = "https://api.bitlabs.ai/v1/client/networks/12345/surveys/34334/leave"
    let noURL = "https://api.bitlabs.ai/v1/client/networkss/12345/surveyss/34334/leave"
    public static let instance = BrowserDelegate()
    
    var networkID = ""
    var surveryID = ""
    
    let urlRegEx = "\\/networks\\/(\\d+)\\/surveys\\/(\\d+)"
    
    var observation: NSKeyValueObservation?
    var visual = Visual()
    
   // var wkWebView: WKWebView
    var safariController: SFSafariViewController?
    weak var parentViewController: UIViewController?
    
    var webViewController: WebViewController
    
    var shadowWebView: WKWebView
    
    override private init() {
        shadowWebView = WKWebView()
        webViewController = WebViewController()
        super.init()
    }

    
    // TODO: Implement the check for the BitLabs - URL
    private func containsBitLabURL(url: String ) -> Bool {
        return url.starts(with: Constants.baseURL)
    }
    
    private func checkForNetworkAndSurveyId( urlToCheck: String) throws -> (networkId: String, surveyId: String)?{
        
        let regEx = try NSRegularExpression(pattern: urlRegEx, options: .caseInsensitive)
        let range = NSMakeRange(0, urlToCheck.count)
        let matches = regEx.matches(in: urlToCheck, options: .withTransparentBounds, range: range)
        
        if matches.isEmpty {
            return nil
        }
        
        guard let url = URL(string: urlToCheck) else {
            return nil
        }
        
        let pathComponents = url.pathComponents
        guard let networksIndex = pathComponents.index(of: "networks"), let surveysIndex = pathComponents.index(of: "surveys") else {
            return nil
        }
        
        
        let networkId = pathComponents[networksIndex+1]
        let surveyId = pathComponents[surveysIndex+1]
        return (networkId: networkId , surveyId: surveyId)
    }
    
    
    func show(parent: UIViewController, withUserId userId : String, token: String, visual: Visual? )   {
        let url = buildURL(userId: userId, apiToken: token)
        
        guard let u = url else {
            debugPrint("| Invalid url")
            return
        }
       
        if visual != nil {
            self.visual = visual!
        }
        
        shadowWebView.navigationDelegate = self
     
        webViewController.delegate = self
        webViewController.modalPresentationStyle = .fullScreen
        parent.present(webViewController, animated: true)
        parentViewController = parent

        webViewController.webView?.uiDelegate = self
        webViewController.webView?.navigationDelegate = self

        
        let urlRequest = URLRequest(url: u)
        webViewController.webView!.load(urlRequest)

    }
     
    
    func buildURL(userId: String, apiToken: String) -> URL? {
        var components = URLComponents(string: Constants.baseURL)!
        let queryUUID = URLQueryItem(name: "uid", value: userId)
        let queryAPIToken = URLQueryItem(name: "token", value: apiToken)
        components.queryItems = [queryUUID, queryAPIToken]
        
        do {
            let url = try components.asURL()
            return url
        } catch( let error ) {
            debugPrint("| Error creating URL_ \(error)")
        }
        
        return nil
    }
    
    
}

extension BrowserDelegate: WKUIDelegate {
    
}

extension BrowserDelegate: WKNavigationDelegate {
    
    
    public func webView(_ webView: WKWebView, didFinish: WKNavigation!) {
        var i = 2
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let urlStr = navigationAction.request.url?.absoluteString
       
        if urlStr == nil {
            decisionHandler(.allow)
            return
        }
        
        if containsBitLabURL(url: urlStr!) {
            configureLayoutOne()
            decisionHandler(.allow)
            return
        }
        
        let textColor = calculateTextColor(visual: visual)
        configureLayoutTwo()
        do {
            guard let result = try checkForNetworkAndSurveyId(urlToCheck: urlStr!) else {
                decisionHandler(.allow)
                return
            }
            networkID = result.networkId
            surveryID = result.surveyId
            
        } catch {
            debugPrint("Error extracting networkId and surveyId: \(error)")
        }
        decisionHandler(.allow)
    }

    func calculateTextColor( visual: Visual) -> UIColor {
        let baseColor = visual.colorLight.cgColor
        let components = baseColor.components
        
        let red = components![0]
        let green = components![1]
        let blue = components![2]
        
        let calcRed = red * 0.299
        let calcGreen = green * 0.587
        let calcBlue = blue * 0.114
        
        let calcSum = calcRed + calcGreen + calcBlue
        
        if calcSum >= 186 {
            return UIColor.black
        } else {
            return UIColor.white
        }
    }
    
    func configureLayoutOne() {
        
        let textColor = calculateTextColor(visual: visual)
        
        webViewController.topBar?.isHidden = false
        webViewController.topBar?.backgroundColor = visual.colorLight
        
        webViewController.closeButton?.isHidden = false
        webViewController.closeButton?.isUserInteractionEnabled = true
        webViewController.closeButton?.tintColor = textColor
        
        webViewController.navigateBackButton?.isHidden = true
        webViewController.navigateBackButton?.isUserInteractionEnabled = false
    }
    
    func configureLayoutTwo() {
        let textColor = calculateTextColor(visual: visual)
        
        webViewController.topBar?.isHidden = false
        webViewController.topBar?.backgroundColor = visual.colorLight
        
        webViewController.navigateBackButton?.isHidden = false
        webViewController.navigateBackButton?.isUserInteractionEnabled = true
        webViewController.navigateBackButton?.tintColor = textColor
        
        webViewController.closeButton?.isHidden = true
        webViewController.closeButton?.isUserInteractionEnabled = false
    }
    
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
          print(#function)
          if webView != shadowWebView { return }
          
          let url = shadowWebView.url?.absoluteURL
      }
    
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            let urlRequest = navigationAction.request
    
            observation = shadowWebView.observe( \WKWebView.estimatedProgress , options: [.new ]) { object, change in
                guard let progress = change.newValue else { return }
                
                if progress >= 1.0 {
                    let url = self.shadowWebView.url!

                    if !UIApplication.shared.canOpenURL(url) {
                           return
                    }
                    self.safariController = SFSafariViewController(url: url)
                    self.parentViewController?.present( self.safariController!, animated: true)
                }
            }
            shadowWebView.load(urlRequest)
        }
        return nil
    }
    

}
 
extension BrowserDelegate: WebViewControllerDelegate {
    
    func handleCloseAction(_ webViewController: WebViewController) {
        webViewController.dismiss(animated: true )
    }
    
    func handleNavigateBackAction(_ webViewController: WebViewController) {
        // TODO: Implement
        var i = 2
    }
    
    func confirmLeaving(_ webViewController: WebViewController ) {
        
    }
    
}
