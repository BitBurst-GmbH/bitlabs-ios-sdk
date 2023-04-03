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
    
    private let uid = "YOUR_USER_ID"
    private let token = "7afbdd12-1a97-4496-bcbe-1d0a7376427e"
    
    @IBOutlet weak var surveysContainer: UIView!
    @IBOutlet weak var leaderboardContainer: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        BitLabs.shared.configure(token: token, uid: uid)
        
        BitLabs.shared.setTags(["userType": "New", "isPremium": false])
        BitLabs.shared.setRewardCompletionHandler { reward in
            print("[Example] You earned: \(reward)")
        }
        
        setupLeaderboard()
    }
    
    func setupLeaderboard() {
        BitLabs.shared.getLeaderboardView(parent: self) { leaderboard in
            guard let leaderboard = leaderboard else { return }
            
            leaderboard.frame = self.leaderboardContainer.bounds

            self.leaderboardContainer.addSubview(leaderboard)
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

                let collection = BitLabs.shared.getSurveyWidgets(surveys: surveys, parent: self, type: .full_width)
                collection.frame = self.surveysContainer.bounds

                self.surveysContainer.addSubview(collection)
            }
        }
    }
}
