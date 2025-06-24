//
//  MainViewController.swift
//  BitLabs
//
//  Created by BitBurst GmbH on 11/09/2020.
//  Copyright (c) 2021 BitBurst GmbH. All rights reserved.
//

import BitLabs
import UIKit

class MainViewController: UIViewController {
    
    private let uid = "oblivatevariegata"
    private var token = "YOUR_APP_TOKEN"
    
    private var offerwall: Offerwall!
    
    @IBOutlet weak var surveysContainer: UIView!
    @IBOutlet weak var leaderboardContainer: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
           let plist = try? PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? Dictionary<String, String> {
            token = plist["APP_TOKEN"] ?? token
        }
        
        offerwall = BitLabs.OFFERWALL.create(token: token, uid: uid)
        
        
        offerwall.tags["user_type"] = "New"
        offerwall.tags["is_premium"] = false
        
        offerwall.offerwallClosedHandler = { totalReward in
            print("[Example] You earned: \(totalReward)")
        }
    }
    
    @IBAction func requestTrackingAuthorization(_ sender: UIButton) {
        offerwall.requestTrackingAuthorization()
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
    
    @IBAction func showLeaderboard(_ sender: Any) {
        BitLabs.shared.showLeaderboard(in: leaderboardContainer)
    }
    
    @IBAction func showOfferWall(_ sender: UIButton) {
        offerwall.launch(parent: self)
    }
    
    @IBAction func getSurveys(_ sender: UIButton) {
        BitLabs.shared.getSurveys { result in
            switch result {
            case .failure(let error):
                print("[Example] Get Surveys \(error)")

            case .success(let surveys):
                print("[Example] \(surveys.map { "Survey \($0.id) in Category \($0.category.name)" })")
            }
        }
    }
    
    @IBAction func showSurveyWidget(_ sender: Any) {
        BitLabs.shared.showSurveyWidget(in: surveysContainer, type: .simple)
    }
}
