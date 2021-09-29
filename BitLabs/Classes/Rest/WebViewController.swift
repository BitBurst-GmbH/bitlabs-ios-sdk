//
//  WebViewController.swift
//  Alamofire
//
//  Created by BitBurst GmbH on 14.11.20.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    enum Constants {
        static let xibName = String(describing: WebViewController.self)
        static let bundle = Bundle(for: WebViewController.self)
    }
    
    weak var delegate: WebViewControllerNavigationDelegate?
    var currentLayout: Layout!
    var leaveOptionsMenu: UIAlertController!
    let podBundle = Bundle.init(for: WebViewController.self )

    @IBOutlet weak var topBar: UIView?
    @IBOutlet weak var closeButtonBar: UIView?
    @IBOutlet weak var closeButton: UIButton?
    @IBOutlet weak var navigateBackButton: UIButton?
    
    @IBOutlet weak var webView: WKWebView?
    
    @IBOutlet weak var webViewToSafeArea: NSLayoutConstraint?
    @IBOutlet weak var webViewToTopBarBottom: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(nibName: Constants.xibName, bundle: Constants.bundle)
        currentLayout = .LAYOUT_ONE
    }
  

    @IBAction func handleCloseAction( _ sender: UIButton) {
        self.delegate?.handleCloseAction(controller: self)
    }
    
    @IBAction func handleBackNavigationAction(_ sender: UIButton) {
        let leaveTitle = NSLocalizedString( "LEAVE_TITLE", bundle: podBundle, value: "", comment: "")
        leaveOptionsMenu = UIAlertController(title: "Leave", message: leaveTitle , preferredStyle: .alert)
        
        for reason in LeaveReason.allCases {
            let translatedTextValue = NSLocalizedString( reason.rawValue, bundle: podBundle, value: "", comment: "")
            let reasonEntry = UIAlertAction(title: translatedTextValue, style: .default, handler: { _ in
                self.delegate?.handleLeaveSurvey(controller: self , reason: reason)
            })
            leaveOptionsMenu.addAction(reasonEntry)
        }
        let translatedValue = NSLocalizedString( "CONTINUE_SURVEY", bundle: podBundle, value: "", comment: "")
        let continueSurvey = UIAlertAction(title: translatedValue, style: .cancel, handler: nil)
        leaveOptionsMenu.addAction(continueSurvey)
        
        self.present(leaveOptionsMenu, animated: true, completion: nil)
    }
   
}
