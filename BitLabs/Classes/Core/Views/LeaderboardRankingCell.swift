//
//  LeaderboardRankingCell.swift
//  BitLabs
//
//  Created by Omar Raad on 23.03.23.
//

import Foundation

@IBDesignable class LeaderboardRankingCell: UICollectionViewCell {
    
    @IBOutlet weak var rankLabel: UILabel?
    @IBOutlet weak var usernameLabel: UILabel?
    @IBOutlet weak var topLabel: UILabel?
    @IBOutlet weak var rewardLabel: UILabel?
    @IBOutlet weak var currencyImageView: UIImageView?
    
    @IBInspectable
    var rank: Int = 0 { didSet {
        rankLabel?.text = String(rank)
        topLabel?.text = rank < 4 ? String(rank) : ""
    }}
    
    @IBInspectable
    var reward: String = "" { didSet {
        rewardLabel?.text = reward
    }}
    
    @IBInspectable
    var username: String = "anonymous" { didSet {
        usernameLabel?.text = String(username)
    }}
    
    @IBInspectable
    var currencyIcon: UIImage? = nil { didSet {
        currencyImageView?.image = currencyIcon
    }}
}
