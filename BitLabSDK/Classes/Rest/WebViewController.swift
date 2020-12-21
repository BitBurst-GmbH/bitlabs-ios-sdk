//
//  WebViewController.swift
//  Alamofire
//
//  Created by Frank Marx on 16.12.20.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    weak var delegate: WebViewControllerDelegate?
    
    enum Constants {
        static let xibName = String(describing: WebViewController.self)
        static let bundle = Bundle(for: WebViewController.self)
    }
    
    @IBOutlet weak var topBar: UIView?
    @IBOutlet weak var closeButton: UIButton?
    @IBOutlet weak var navigateBackButton: UIButton?
    
    @IBOutlet weak var webView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let v = self.view
        
        var i = 2
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(nibName: Constants.xibName, bundle: Constants.bundle)
    }
  

    @IBAction func handleCloseAction( _ sender: UIButton) {
        self.delegate?.handleCloseAction?(self)
    }
    
    @IBAction func handleBackNavigationAction(_ sender: UIButton) {
        self.delegate?.handleNavigateBackAction?(self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
