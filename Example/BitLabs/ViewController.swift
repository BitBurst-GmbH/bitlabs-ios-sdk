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
        
        BitLabs.shared.setTags(["userType": "New", "isPremium": false])
        BitLabs.shared.setRewardCompletionHandler { reward in
            print("[Example] You earned: \(reward)")
        }
    }
    
    @IBAction func requestTrackingAuthorization(_ sender: UIButton) {
        BitLabs.shared.requestTrackingAuthorization()
    }
    
    @IBAction func checkForSurveys(_ sender: UIButton ) {
        BitLabs.shared.checkSurveys { result in
            switch result {
            case .failure(let error):
                print("[Example] Check For Surveys \(error)")
            case .success(let hasSurveys):
                print("[Example] \(hasSurveys ? "Surveys Available!":"No Surveys Available!")")
            }
        }
    }
    
    @IBAction func showOfferWall(_ sender: UIButton) {
        BitLabs.shared.launchOfferWall(parent: self)
    }
    
    @IBAction func getSurveys(_ sender: UIButton) {
        BitLabs.shared.getSurveys { result in
            switch result {
            case .failure(let error):
                print("[Example] Get Surveys \(error)")
                
            case .success(let surveys):
                print("[Example] \(surveys.map { "Survey \($0.id) in Category \($0.details.category.name)" })")
            }
        }
    }
}
