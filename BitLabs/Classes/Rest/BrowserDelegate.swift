//
//  BrowserDelegate.swift
//  BitLabs
//
//  Created by BitBurst GmbH on 14.11.20.
//

import UIKit
import SafariServices
import WebKit

@objc
protocol WebViewControllerDelegate {
    @objc optional func handleCloseAction( _ webViewController: WebViewController)
    @objc optional func handleNavigateBackAction( _ webViewController: WebViewController)
}


protocol WebViewControllerNavigationDelegate: AnyObject{
    func handleLeaveSurvey( controller: UIViewController, reason: LeaveReason)
    func handleCloseAction( controller: WebViewController)
}

public class BrowserDelegate: NSObject {
    
    public enum Constants {
        public static let baseURL = "https://web.bitlabs.ai"
        public static let apiTokenHeader = "X-Api-Token"
        public static let userIdHeader = "X-User-Id"
        public static let urlStartsWith = "web.bitlabs.ai"
    }
 
    public static let instance = BrowserDelegate()
    
    var networkID = ""
    var surveryID = ""
    
    var userId = ""
    var token = ""
    var tags: Dictionary<String, Any> = [:]
    
    var currentLayout: Layout = .LAYOUT_ONE
    var restService: RestService?
    var bitlabs: BitLabs?
    var onRewardHandler: ((Float)-> ())?
    
    var navigateToInitialPage: WKNavigation? = nil
    
    let urlRegEx = "\\/networks\\/(\\d+)\\/surveys\\/(\\d+)"
    
    var observation: NSKeyValueObservation?
 
    var safariController: SFSafariViewController?
    weak var parentViewController: UIViewController?
    
    var webViewController: WebViewController
    
    var shadowWebView: WKWebView
    
    override private init() {
        shadowWebView = WKWebView()
        webViewController = WebViewController()
        super.init()
    }

    private func containsBitLabURL(url: String ) -> Bool {
        return url.starts(with: Constants.baseURL)
    }
    
    private func checkForNetworkAndSurveyId(urlToCheck: String) throws -> (networkId: String, surveyId: String)?{
        
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
        guard let networksIndex = pathComponents.firstIndex(of: "networks"), let surveysIndex = pathComponents.firstIndex(of: "surveys") else {
            return nil
        }
        
        
        let networkId = pathComponents[networksIndex+1]
        let surveyId = pathComponents[surveysIndex+1]
        return (networkId: networkId , surveyId: surveyId)
    }
    
    func getQueryStringParameter(url: String, param: String) -> String? {
      guard let url = URLComponents(string: url) else { return nil }
      return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    func show(parent: UIViewController, withUserId userId : String, token: String, tags: Dictionary<String, Any>, bitlabs: BitLabs)   {

        let url = buildURL(userId: userId, apiToken: token, tags: tags)
        self.userId = userId
        self.token = token
        self.tags = tags
        self.bitlabs = bitlabs
        
        guard let u = url else {
            debugPrint("| Invalid url")
            return
        }
        
        if webViewController.isBeingPresented {
            return
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
     
    
    func buildURL(userId: String, apiToken: String, tags: Dictionary<String, Any>) -> URL? {
        var components = URLComponents(string: Constants.baseURL)!
        let queryUUID = URLQueryItem(name: "uid", value: userId)
        let queryAPIToken = URLQueryItem(name: "token", value: apiToken)
        components.queryItems = [queryUUID, queryAPIToken]
        
        tags.forEach {
            components.queryItems?.append(URLQueryItem(name: $0, value: String(describing: $1)))
        }
        
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
                    if let webVC = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController as? WebViewController {
                        webVC.present( self.safariController!, animated: true)
                    } else {
                        self.parentViewController?.present( self.safariController!, animated: true)
                    }
             
                }
            }
            shadowWebView.load(urlRequest)
        }
        return nil
    }

}

extension BrowserDelegate: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFinish: WKNavigation!) {
    
        if currentLayout == .LAYOUT_TWO {
            webViewController.navigateBackButton?.isEnabled = true
        }
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let urlStr = navigationAction.request.url?.absoluteString
       
        if urlStr == nil {
            decisionHandler(.allow)
            return
        }
        
        if (urlStr!.contains("survey/complete") || urlStr!.contains("survey/screenout")){
            let value = getQueryStringParameter(url: urlStr!, param: "val") ?? "0"
            onRewardHandler!((value as NSString).floatValue)
        }
        
        if containsBitLabURL(url: urlStr!) {
            configureLayoutOne()
            decisionHandler(.allow)
            return
        }
      
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
    
    func configureLayoutOne() {
        
        webViewController.webViewToTopBarBottom?.priority = UILayoutPriority(999)
        webViewController.webViewToSafeArea?.priority = UILayoutPriority.init(1000)
       
        webViewController.topBar?.isHidden = true
        
        webViewController.closeButton?.isHidden = false
        webViewController.closeButton?.isUserInteractionEnabled = true
        webViewController.closeButton?.tintColor = UIColor.darkGray
        
        webViewController.navigateBackButton?.isHidden = true
        webViewController.navigateBackButton?.isUserInteractionEnabled = false
        
        currentLayout = .LAYOUT_ONE
    }
    
    func configureLayoutTwo() {

        webViewController.webViewToSafeArea?.priority = UILayoutPriority.init(999)
        webViewController.webViewToTopBarBottom?.priority = UILayoutPriority(1000)
        
        webViewController.navigateBackButton?.isEnabled = true
        webViewController.topBar?.isHidden = false
        webViewController.topBar?.backgroundColor = UIColor.white
        
        webViewController.navigateBackButton?.isHidden = false
        webViewController.navigateBackButton?.isUserInteractionEnabled = true
        
        webViewController.closeButton?.isHidden = true
        webViewController.closeButton?.isUserInteractionEnabled = false
        
        currentLayout = .LAYOUT_TWO
    }
    
}
 
extension BrowserDelegate: WebViewControllerNavigationDelegate {
    func handleLeaveSurvey(controller: UIViewController , reason: LeaveReason) {
        guard let rs = restService else { return }
        
        guard let wvc = controller as? WebViewController else {
            debugPrint("| Provided controller is not of type WebViewController")
            controller.dismiss(animated: true, completion: nil)
            return
        }
        wvc.navigateBackButton?.isEnabled = false
        
        rs.leaveSurvey(networkId: networkID, surveyId: surveryID, reason: reason) {
            
            let url = self.buildURL(userId: self.userId, apiToken: self.token, tags: self.tags)
            let urlRequest = URLRequest(url: url!)

            self.configureLayoutOne()
            self.navigateToInitialPage = wvc.webView!.load(urlRequest)
        }
    }
    
    func handleCloseAction(controller: WebViewController) {
        webViewController.dismiss(animated: true )
    }
}
