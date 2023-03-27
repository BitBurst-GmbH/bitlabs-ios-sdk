//
//  LeaderboardView.swift
//  BitLabs
//
//  Created by Omar Raad on 27.03.23.
//

import Foundation

class LeaderboardView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var ownUserRank: UILabel?
    @IBOutlet weak var rankings: UICollectionView?
    
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
        let nib = UINib(nibName: "LeaderboardView", bundle: bundle)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
}
