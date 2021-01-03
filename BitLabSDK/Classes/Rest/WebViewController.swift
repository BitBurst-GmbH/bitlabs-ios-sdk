//
//  WebViewController.swift
//  Alamofire
//
//  Created by Frank Marx on 16.12.20.
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
    var visual = Visual()
    
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
        leaveOptionsMenu = UIAlertController(title: "Leave", message: "Choose a reason for leaving the survey", preferredStyle: .alert)
        
        leaveOptionsMenu.view.tintColor = visual.colorAccent
        
        for reason in LeaveReason.allCases {
            let reasonEntry = UIAlertAction(title: reason.rawValue, style: .default, handler: { _ in
                self.delegate?.handleLeaveSurvey(controller: self , reason: reason)
            })
            leaveOptionsMenu.addAction(reasonEntry)
        }
        let continueSurvey = UIAlertAction(title: "Continue the survey", style: .cancel, handler: nil)
        leaveOptionsMenu.addAction(continueSurvey)
        
        self.present(leaveOptionsMenu, animated: true, completion: nil)
    }
   
}
