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

    let token = "46d31e1e-315a-4b52-b0de-eca6062163af"
    let uid = "YOUR_USER_ID1"
    
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
        bitlabs?.setRewardCompletionHandler { payout in
            debugPrint("You earned: \(payout)")
        }
    }
    
    
    @IBAction func checkForSurveys( _ sender: UIButton ) {
        bitlabs?.checkSurveys { result in
            switch result {
            case true:
                print("[Example] Surveys available!")
            case false:
                print("[Example] No surveys available!")
            }
        }
    }
    
    @IBAction func showOfferWall(_ sender: UIButton) {
        bitlabs?.launchOfferWall(parent: self)
    }
}
