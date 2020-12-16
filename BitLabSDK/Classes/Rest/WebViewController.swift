//
//  WebViewController.swift
//  Alamofire
//
//  Created by Frank Marx on 16.12.20.
//

import UIKit

class WebViewController: UIViewController {

    enum Constants {
        static let xibName = String(describing: WebViewController.self)
        static let bundle = Bundle(for: WebViewController.self)
    }
    
    @IBOutlet weak var topBar: UIView?
    @IBOutlet weak var closeButton: UIButton?
    
    
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
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
