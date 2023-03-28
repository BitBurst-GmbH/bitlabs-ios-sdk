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
    
    
    var leaderboardDataSource: LeaderboardDataSource? = nil
    
    var ownUser: OwnUser? = nil { didSet {
        guard let ownUser = ownUser else { return }
        
        ownUserRankLabel?.text = "You are currently ranked \(ownUser.rank) on our leaderboad."
    }}
    
    var rankings: [TopUser] = [] { didSet {
        setupRankingList(rankings)
    }}
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
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
    
    private func setupRankingList(_ rankings: [TopUser]) {
        guard let collectionView = rankingsCollectionView else { return }
        leaderboardDataSource = LeaderboardDataSource()
        collectionView.dataSource = leaderboardDataSource
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.itemSize = CGSize(width: 300, height: 55)
        
        
    }
}
