//
//  LeaderboardConfigurer.swift
//  BitLabs
//
//  Created by Omar Raad on 26.03.23.
//

import Foundation

class LeaderboardConfigurer: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var topUsers: [TopUser]
    var image: UIImage?
    
    init(topUsers: [TopUser], image: UIImage?) {
        self.topUsers = topUsers
        self.image = image
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LeaderboardRankingCell", for: indexPath) as! LeaderboardRankingCell
        
        let user = topUsers[indexPath.item]
        
        cell.rank = user.rank
        cell.username = user.name
        cell.reward = String(user.earningsRaw)
        cell.currencyIcon = image
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
}
