//
//  WidgetView.swift
//  BitLabs
//
//  Created by Omar Raad on 31.01.24.
//

import Foundation
import WebKit


public class WidgetView: UIView, UIGestureRecognizerDelegate {
    
    let webview = WKWebView()
    
    var type = WidgetType.leaderboard
    var token = ""
    var uid = ""
    
    init(frame: CGRect, token: String, uid: String, type: WidgetType) {
        super.init(frame: frame)
        self.token = token
        self.uid = uid
        self.type = type
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        if token.isEmpty || uid.isEmpty {
            return print("[BitLabs] Token or UID found empty! Can't show the widget.")
        }
                
        // webview properties
        webview.frame = { switch type {
        case .simple:
            return CGRect(origin: .zero, size: CGSize(width: 280, height: 130))
        case .compact:
            return CGRect(origin: .zero, size: CGSize(width: 250, height: 75))
        case .full_width:
            return CGRect(origin: .zero, size: CGSize(width: bounds.width, height: 60))
        case .leaderboard:
            return bounds
        }}()
        addSubview(webview)
        webview.isOpaque = false
        
        webview.scrollView.bounces = false
        
        let string = """
        <!DOCTYPE html>
        <html lang="en">
          <head>
            <meta charset="utf-8" />
            <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no' />
            <style>
              html,
              body,
              #widget {
                height: 100%;
                margin: 0%;
              }
            </style>
            <script src="https://sdk.bitlabs.ai/bitlabs-sdk-v0.0.2.js"></script>
            <link
              rel="stylesheet"
              href="https://sdk.bitlabs.ai/bitlabs-sdk-v0.0.2.css"
            />
            <title>Leaderboard</title>
          </head>
          <body>
            <div id="widget"></div>

            <script>
              function initSDK() {
                window.bitlabsSDK
                  .init("\(token)", "\(uid)")
                  .then(() => {
                    window.bitlabsSDK.showWidget("#widget", "\(type.rawValue)", {
                      onClick: () => {},
                    });

                    document.removeEventListener("DOMContentLoaded", this.initSDK);
                  });
              }

              document.addEventListener("DOMContentLoaded", this.initSDK);
            </script>
          </body>
        </html>
        """
        
        webview.loadHTMLString(string, baseURL: URL(string: "https://sdk.bitlabs.ai/"))
        
        // view properties
        isUserInteractionEnabled = true
        frame.size = webview.bounds.size  // make view similar to webview
        
        let gesture = UITapGestureRecognizer(target: parentViewController ?? self, action: #selector(onTap))
        gesture.delegate = self
        addGestureRecognizer(gesture)
        
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func onTap() {
        print("lolo called")
        guard let parent = parentViewController else {
            print("[BitLabs] Looks like the WidgetView instance doesn't have a parent VC! Can't launch OfferWall")
            return
        }
        
        BitLabs.shared.launchOfferWall(parent: parent)
    }
}
