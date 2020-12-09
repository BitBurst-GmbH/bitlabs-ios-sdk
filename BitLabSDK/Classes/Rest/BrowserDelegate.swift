//
//  BrowserDelegate.swift
//  BitLabSDK
//
//  Created by Frank Marx on 20.11.20.
//

import UIKit
import SafariServices
import WebKit

public class BrowserDelegate: NSObject {
    
    public enum Constants {
        public static let baseURL = "https://web.bitlabs.ai"
        public static let apiTokenHeader = "X-Api-Token"
        public static let userIdHeader = "X-User-Id"

    }
    
    public static let instance = BrowserDelegate()
    
    var observation: NSKeyValueObservation?
    
    var wkWebView: WKWebView
    var safariController: SFSafariViewController?
    weak var parentViewController: UIViewController?
    
    var shadowWebView: WKWebView
    
    override private init() {
        wkWebView = WKWebView()
        wkWebView.allowsBackForwardNavigationGestures = true
        shadowWebView = WKWebView()
    }

    public func show(parent: UIViewController, withUserId userId : String, token: String )   {
        let url = buildURL(userId: userId, apiToken: token)
        
        guard let u = url else {
            debugPrint("| Invalid url")
            return
        }
       
        shadowWebView.navigationDelegate = self
        wkWebView.uiDelegate = self
        wkWebView.navigationDelegate = self
        
        parent.view = wkWebView
        parentViewController = parent
        
        let urlRequest = URLRequest(url: u)
        wkWebView.load(urlRequest)

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
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
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
            let ur = URLRequest(url: URL(string: "https://www.google.de")!)
            shadowWebView.load(ur)
        }
        return nil
    }
}
 
