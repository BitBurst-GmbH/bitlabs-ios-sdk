//
//  LeaderboardRankingView.swift
//  BitLabs
//
//  Created by Omar Raad on 23.03.23.
//

import Foundation

@IBDesignable class LeaderboardRankingView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var currencyImageView: UIImageView!
    
    @IBInspectable
    var rank: Int = 0 { didSet {
        rankLabel.text = String(rank)
    }}
    
    @IBInspectable
    var reward: String = "" { didSet {
        rewardLabel.text = reward
    }}
    
    @IBInspectable
    var username: String = "anonymous" { didSet {
        usernameLabel.text = String(username)
    }}
    
    @IBInspectable
    var currencyIcon: UIImage? = nil { didSet {
        currencyImageView.image = currencyIcon
    }}
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "LeaderboardRankingView", bundle: bundle)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
}
