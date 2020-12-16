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
    
    var wkWebView: WKWebView
    var safariController: SFSafariViewController?
    weak var parentViewController: UIViewController?
    
    var webViewController: WebViewController
    
    var shadowWebView: WKWebView
    
    override private init() {
        webViewController = WebViewController()
        wkWebView = WKWebView()
        wkWebView.allowsBackForwardNavigationGestures = true
        shadowWebView = WKWebView()
        super.init()
//        do {
//            let result = try checkForNetworkAndSurveyId(urlToCheck: exampleURL)
//        } catch {
//            // should never happen
//        }
        
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
    
    
    func show(parent: UIViewController, withUserId userId : String, token: String )   {
        let url = buildURL(userId: userId, apiToken: token)
        
        guard let u = url else {
            debugPrint("| Invalid url")
            return
        }
       
        shadowWebView.navigationDelegate = self
        wkWebView.uiDelegate = self
        wkWebView.navigationDelegate = self
    
        parent.present(webViewController, animated: true)
    //    parent.addChildViewController(webViewController)
   //     let wView = webViewController.view
    // parent.view = webViewController.view
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
            //configureLayoutOne
            decisionHandler(.allow)
            return
        } else {
            // configureLayoutTwo
            decisionHandler(.allow)
            return
        }
        
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
 
