//
//  Offerwall.swift
//  Pods
//
//  Created by Omar Raad on 23.06.25.
//

import AdSupport
import AppTrackingTransparency
import UIKit

public class Offerwall: WebViewDelegate {
    private let uid: String
    private let token: String
    private let bitlabsAPI: BitLabsAPI
    
    private var adId = ""
    private var headerColor = ["000000", "000000"]
    
    public var tags: [String: Any] = [:]
    public var options: [String: Any] = [:]
    
    public var surveyRewardHandler: ((_ reward: Double) -> Void) = { _ in }
    public var offerwallClosedHandler: ((_ totalReward: Double) -> Void) = {_ in }
    
    init(token: String, uid: String) {
        self.token = token
        self.uid = uid
        
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "User-Agent": createUserAgent(),
            "X-Api-Token": token,
            "X-User-Id": uid
        ]
        
        bitlabsAPI = BitLabsAPI(URLSession(configuration: config))
        
        getAppSettings()
        
        guard #available(iOS 14, *), case .authorized = ATTrackingManager.trackingAuthorizationStatus
        else { return }
        
        adId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    private func getAppSettings() {
        bitlabsAPI.getAppSettings(token: token) { [weak self] config in
            guard let self = self else { return }
            
            let theme = "light"
            
            let navigationColor = config.first { $0.internalIdentifier == "app.visual.\(theme).navigation_color"}?.value ?? ""
            self.headerColor = navigationColor.extractColors
        }
    }
    
    public func requestTrackingAuthorization() {
        guard #available(iOS 14, *) else { return }
        
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                self.adId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            default:
                break
            }
        }
    }
    
    public func launch(parent: UIViewController) {
        let webViewController = WebViewController(nibName: String(describing: WebViewController.self), bundle: bundle)
        
        webViewController.uid = uid
        webViewController.initialURL = generateURL(
            uid: uid,
            token: token,
            sdk: SubspecConfig.SDK,
            adId: adId,
            options: options,
            tags: tags)
        
        webViewController.delegate = self
        webViewController.color = headerColor.map { $0.toUIColor ?? .black }
        
        webViewController.modalPresentationStyle = .overFullScreen
        
        parent.present(webViewController, animated: true)
    }
    
    func offerwallClosed(_ value: Double) {
        offerwallClosedHandler(value)
    }
    
    func rewardEarned(_ reward: Double) {
        surveyRewardHandler(reward)
    }
    
    func sendLeaveSurveyRequest(clickId: String, reason: LeaveReason, _ completion: @escaping () -> ()) {
        bitlabsAPI.leaveSurvey(clickId: clickId, reason: reason, completion: completion)
    }
}
