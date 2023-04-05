//
//  LeaderboardView.swift
//  BitLabs
//
//  Created by Omar Raad on 27.03.23.
//

import Foundation

public class LeaderboardView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var ownUserRankLabel: UILabel?
    @IBOutlet weak var rankingsCollectionView: UICollectionView?
    
    
    var leaderboardConfigurer: LeaderboardConfigurer? = nil
    
    var ownUser: OwnUser? = nil { didSet {
        guard let ownUser = ownUser else { return }
        
        ownUserRankLabel?.text = "You are currently ranked \(ownUser.rank) on our leaderboad."
    }}
    
    var rankings: [TopUser] = [] { didSet {
        setupRankingList()
    }}
    
    var currencyIconUrl: String = ""
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initSubviews()
    }
    
    init(currencyIconUrl: String, frame: CGRect) {
        self.currencyIconUrl = currencyIconUrl
        super.init(frame: frame)

        initSubviews()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initSubviews()
    }
    
    private func initSubviews() {
        let nib = UINib(nibName: "LeaderboardView", bundle: bundle)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    private func setupRankingList() {
        guard let collectionView = rankingsCollectionView else { return }
        
        BitLabs.shared.getCurrencyIcon(currencyIconUrl: currencyIconUrl) { image in
            self.leaderboardConfigurer = LeaderboardConfigurer(topUsers: self.rankings, image: image)
            collectionView.dataSource = self.leaderboardConfigurer
            collectionView.delegate = self.leaderboardConfigurer
            
            collectionView.register(UINib(nibName: "LeaderboardRankingCell", bundle: bundle), forCellWithReuseIdentifier: "LeaderboardRankingCell")
        }
    }
}
