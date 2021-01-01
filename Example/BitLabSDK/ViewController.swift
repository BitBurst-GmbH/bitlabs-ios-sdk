//
//  ViewController.swift
//  BitLabSDK
//
//  Created by Frank Marx on 11/09/2020.
//  Copyright (c) 2020 Frank Marx. All rights reserved.
//

import BitLabSDK
import UIKit

class ViewController: UIViewController {

    let token = "6c7083df-b97e-4d29-9d90-798fd088bc08"
  //  var restService: RestService?
  //  var browserDelegagte: BrowserDelegate?
    
    var bitLabSDK: BitLabInterface?
    
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
        
        bitLabSDK = BitLabFacade.Init(token: token, uid: "marxfr")
        
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
        bitLabSDK?.checkForSurveys(forPlatform: .MOBILE) { result in
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
      //  let sfController = browserDelegagte?.show(parent: self.view, withUserId: "marxfr", token: token)
    
        bitLabSDK?.retrieveSettings() { result in
            switch result {
            case .success(let entity):
                debugPrint(entity)
                self.bitLabSDK?.show(parent: self)
            case .failure(let error):
                debugPrint(error)
                
            }
        }
       
        
       // present( sfController!, animated: true)
        
    }
    
}
