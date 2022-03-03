//
//  ViewController.swift
//  BitLabs
//
//  Created by BitBurst GmbH on 11/09/2020.
//  Copyright (c) 2021 BitBurst GmbH. All rights reserved.
//

import BitLabs
import UIKit

class ViewController: UIViewController {

    let token = "YOUR_APP_TOKEN"
    let uid = "YOUR_USER_ID"
    
    var bitlabs: BitLabs?
    
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
        bitlabs = BitLabs(token: token, uid: uid)
        bitlabs?.setTags(["userType": "New", "isPremium": false])
        bitlabs?.setOnRewardCompletionHandler { payout in
            debugPrint("You earned: \(payout)")
        }
    }
    
    
    @IBAction func checkForSurveys( _ sender: UIButton ) {
        bitlabs?.hasSurveys() { result in
            switch result {
            case true:
                print("[Example] Surveys available!")
            case false:
                print("[Example] No surveys available!")
            }
        }
    }
    
    @IBAction func showWebView(_ sender: UIButton) {
        self.bitlabs?.launchOfferWall(parent: self)
    }
    
}
