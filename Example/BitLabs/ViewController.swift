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
  //  var restService: RestService?
  //  var browserDelegagte: BrowserDelegate?
    
    var bitLabSDK: BitLabsInterface?
    
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
        
        bitLabSDK = BitLabsFacade.Init(token: token, uid: "marxfr")
        
      //  restService = RestService.Init(token: token, uid: "marxfr")
      //  browserDelegagte = BrowserDelegate.instance
//
//        restService?.checkForSurveys(forPlatform: Platform.MOBILE) { result in
//            switch result {
//            case .success(let checkSurveyResponse):
//                debugPrint(checkSurveyResponse)
//            case .failure(let error):
//                debugPrint(error)
//            }
//        }

    }
    
    
    @IBAction func checkForSurveys( _ sender: UIButton ) {
        bitLabSDK?.checkForSurveys() { result in
            switch result {
            case .success(let entity):
                debugPrint(entity)
            case .failure(let error):
                debugPrint(error)
                
            }
            
        }
    }
    
    @IBAction func retrieveSettings( _ sender: UIButton) {
        bitLabSDK?.retrieveSettings() { result in
            switch result {
            case .success(let entity):
                debugPrint(entity)
            case .failure(let error):
                debugPrint(error)
                
            }
        }
        
    }
    
    @IBAction func showWebView(_ sender: UIButton) {
        self.bitLabSDK?.show(parent: self)
    }
    
}