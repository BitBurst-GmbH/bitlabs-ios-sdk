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
    @IBOutlet weak var currencyIV: UIImageView?
    @IBOutlet weak var trophyIV: UIImageView!
    @IBOutlet weak var youLabel: UILabel!
    
    @IBInspectable
    var rank: Int = 0 { didSet {
        rankLabel?.text = String(rank)
        let isTop3 = rank < 4
        topLabel?.text = isTop3 ? String(rank) : ""
        trophyIV?.isHidden = !isTop3
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
        guard let image = currencyIcon else {
            currencyIV?.isHidden = true
            return
        }
        
        currencyIV?.image = image
    }}
    
    @IBInspectable
    var color: UIColor = .black { didSet {
        trophyIV.setImageColor(color: color)
    }}
    
    var isOwnUser: Bool = false { didSet {
        youLabel.isHidden = !isOwnUser
    }}
}
