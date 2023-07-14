//
//  SurveyDataSource.swift
//  BitLabs
//
//  Created by Omar Raad on 08.07.22.
//

import Foundation

public class SurveyDataSource: NSObject, UICollectionViewDataSource {
    
    private let parent: UIViewController
    private let bonusPercentage: Double
    private let surveys: [Survey]
    private let color: [UIColor]
    private let type: WidgetType
    private let imageUrl: String
    
    public init(surveys: [Survey], parent: UIViewController, color: [UIColor], currencyUrl: String, bonus: Double, type: WidgetType) {
        self.bonusPercentage = bonus
        self.imageUrl = currencyUrl
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
        
        let surveyView =  SurveyView(frame: cell.bounds, withType: type)
        surveyView.loi = "\(Int(round(survey.loi))) minutes"
        surveyView.bonusPercentage = Int(bonusPercentage * 100)
        surveyView.rating = survey.rating
        surveyView.reward = survey.value
        surveyView.parent = parent
        surveyView.color = color

        surveyView.oldReward = String(((Double(survey.value) ?? 0.0) / (1 + bonusPercentage)).rounded(toPlaces: 2))

        BitLabs.shared.getCurrencyIcon(currencyIconUrl: imageUrl) {image in surveyView.currencyIcon = image }
        
        cell.addSubview(surveyView)
        
        return cell
    }
}
