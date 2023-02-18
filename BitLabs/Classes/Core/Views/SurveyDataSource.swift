//
//  SurveyDataSource.swift
//  BitLabs
//
//  Created by Omar Raad on 08.07.22.
//

import Foundation

public class SurveyDataSource: NSObject, UICollectionViewDataSource {
    
    private var parent: UIViewController
    private var surveys: [Survey]
    private var color: UIColor
    
    public init(surveys: [Survey], parent: UIViewController, color: UIColor) {
        self.surveys = surveys
        self.parent = parent
        self.color = color
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return surveys.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let survey = surveys[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        
        let surveyView =  CompactSurveyView(frame: CGRect(origin: .zero, size: cell.frame.size))
        surveyView.rating = survey.rating
        surveyView.reward = survey.value
        surveyView.loi = "\(survey.loi) minutes"
        surveyView.parent = parent
        surveyView.color = color
        
        cell.addSubview(surveyView)
        
        return cell
    }
}
