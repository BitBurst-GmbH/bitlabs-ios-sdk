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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        BitLabs.shared.configure(token: token, uid: uid)
    }
    
    @IBAction func requestTrackingAuthorization(_ sender: UIButton) {
        BitLabs.shared.requestTrackingAuthorization()
    }
    
    @IBAction func checkForSurveys(_ sender: UIButton ) {
        BitLabs.shared.checkSurveys { result in
            if result {
                print("[Example] Surveys available!")
            } else {
                print("[Example] No surveys available!")
            }
        }
    }
    
    @IBAction func showOfferWall(_ sender: UIButton) {
        BitLabs.shared.launchOfferWall(parent: self)
    }
    
    @IBAction func getSurveys(_ sender: UIButton) {
        BitLabs.shared.setTags(["userType": "New", "isPremium": false])
        BitLabs.shared.setRewardCompletionHandler { reward in
            print("[Example] You earned: \(reward)")
        }
        BitLabs.shared.getSurveys { surveys in
            print("[Example] \(String(describing: surveys))")
            
            surveys?.first?.open(parent: self)
        }
    }
}
