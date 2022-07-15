//
//  SurveyDataSource.swift
//  BitLabs
//
//  Created by Omar Raad on 08.07.22.
//

import Foundation

public class SurveyDataSource: NSObject, UICollectionViewDataSource {
    
    private var surveys: [Survey]
    
    public init(surveys: [Survey]) {
        self.surveys = surveys
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return surveys.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        cell.addSubview(SurveyView(frame: CGRect(origin: .zero, size: cell.frame.size)))
        
        return cell
    }
}
