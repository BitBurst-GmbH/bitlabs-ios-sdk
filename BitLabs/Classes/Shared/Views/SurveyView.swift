//
//  SurveyView.swift
//  BitLabs
//
//  Created by Omar Raad on 04.07.22.
//

import Foundation

@IBDesignable class SurveyView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var loiLabel: UILabel?
    @IBOutlet weak var earnLabel: UILabel?
    @IBOutlet weak var rewardLabel: UILabel?
    @IBOutlet weak var ratingLabel: UILabel?
    
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    @IBInspectable
    var rating: Int = 3 { didSet {
        if rating < 0 { rating = 0 }
        else if rating > 5 { rating = 5 }
        
        ratingLabel?.text = String(rating)
        determineRating()
    }}
    
    @IBInspectable
    var reward: String = "0.5" { didSet {
        rewardLabel?.text = reward
    }}
    
    @IBInspectable
    var loi: String = "1 minute" { didSet {
        loiLabel?.text = loi
    }}
    
    //     var color = ResourcesCompat.getColor(resources, R.color.colorPrimaryDark, null)
    //         set(value) {
    //             field = value
    //             (findViewById<FrameLayout>(R.id.fl_widget_container)
    //                 .background
    //                 .mutate() as GradientDrawable)
    //                 .setColor(color)
    
    //             earnTV.setTextColor(color)
    //             rewardTV.setTextColor(color)
    //         }
    
    weak var parent: UIViewController?
    
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
        // standard initialization logic
        let nib = UINib(nibName: "SurveyView", bundle: bundle)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        determineRating()
        
        // custom initialization
    }
    
    @IBAction func onPress(_ sender: Any) {
        contentView.alpha = 0.75
        UIView.animate(withDuration: 0.7) { self.contentView.alpha = 1.0 }
        BitLabs.shared.launchOfferWall(parent: parent!)
    }
    
    private func determineRating() {
        if rating >= 1 {
            star1.image = UIImage(named: "star-solid", in: bundle, compatibleWith: nil)
        }
        if rating >= 2 {
            star2.image = UIImage(named: "star-solid", in: bundle, compatibleWith: nil)
        }
        
        if rating >= 3 {
            star3.image = UIImage(named: "star-solid", in: bundle, compatibleWith: nil)
        }
        
        if rating >= 4 {
            star4.image = UIImage(named: "star-solid", in: bundle, compatibleWith: nil)
        }
        
        if rating >= 5 {
            star5.image = UIImage(named: "star-solid", in: bundle, compatibleWith: nil)
        }
    }
}
