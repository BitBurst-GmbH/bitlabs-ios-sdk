//
//  ViewController.swift
//  BitLabSDK
//
//  Created by Frank Marx on 11/09/2020.
//  Copyright (c) 2020 Frank Marx. All rights reserved.
//

import BitLabs
import UIKit

class ViewController: UIViewController {

    let token = "6c7083df-b97e-4d29-9d90-798fd088bc08"
    let uid = "YOUR_USER_ID"
    
    var bitlabs: BitLabsInterface?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bitlabs = BitLabsFacade.Init(token: token, uid: uid)
    }
    
    
    @IBAction func checkForSurveys( _ sender: UIButton ) {
        bitlabs?.checkForSurveys() { result in
            switch result {
            case .success(let entity):
                debugPrint(entity)
            case .failure(let error):
                debugPrint(error)
            }
            
        }
    }
    
    @IBAction func retrieveSettings( _ sender: UIButton) {
        bitlabs?.retrieveSettings() { result in
            switch result {
            case .success(let entity):
                debugPrint(entity)
            case .failure(let error):
                debugPrint(error)
            }
        }
        
    }
    
    @IBAction func showWebView(_ sender: UIButton) {
        self.bitlabs?.show(parent: self)
    }
    
}
