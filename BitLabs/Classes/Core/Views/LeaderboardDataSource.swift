//
//  LeaderboardDataSource.swift
//  BitLabs
//
//  Created by Omar Raad on 26.03.23.
//

import Foundation

class LeaderboardDataSource: NSObject, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        
        let rankingView = LeaderboardRankingView(frame: CGRect(origin: .zero, size: cell.frame.size))
        
        cell.addSubview(rankingView)
        
        return cell
    }
}
