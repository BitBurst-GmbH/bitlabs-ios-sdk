//
//  SurveyDataSource.swift
//  BitLabs
//
//  Created by Omar Raad on 08.07.22.
//

import Foundation

public class SurveyDataSource: NSObject, UICollectionViewDataSource {
    
    private let parent: UIViewController
    private let surveys: [Survey]
    private let color: UIColor
    private let type: WidgetType
    
    public init(surveys: [Survey], parent: UIViewController, color: UIColor, type: WidgetType) {
        self.surveys = surveys
        self.parent = parent
        self.color = color
        self.type = type
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return surveys.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let survey = surveys[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        
        let surveyView =  SurveyView(frame: CGRect(origin: .zero, size: cell.frame.size), withType: type)
        surveyView.rating = survey.rating
        surveyView.reward = survey.value
        surveyView.loi = "\(survey.loi) minutes"
        surveyView.parent = parent
        surveyView.color = color
        
        cell.addSubview(surveyView)
        
        return cell
    }
}
