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
    @IBOutlet weak var rewardLabel: UILabel?
    @IBOutlet weak var ratingLabel: UILabel?
    @IBOutlet weak var earnNowLabel: UILabel?
    @IBOutlet weak var playImageView: UIImageView?
    
    @IBOutlet weak var star1: UIImageView?
    @IBOutlet weak var star2: UIImageView?
    @IBOutlet weak var star3: UIImageView?
    @IBOutlet weak var star4: UIImageView?
    @IBOutlet weak var star5: UIImageView?
    
    @IBInspectable
    var rating: Int = 3 { didSet {
        if rating < 0 { rating = 0 }
        else if rating > 5 { rating = 5 }
        
        ratingLabel?.text = String(rating)
        determineRating()
    }}
    
    @IBInspectable
    var reward: String = "EARN\n0.5" { didSet {
        let rewardStr: String = {
            switch type {
            case .simple: return "EARN \(reward)"
            case .compact: return "EARN\n\(reward)"
            case .full_width: return reward
            }
        }()
        
        rewardLabel?.text = rewardStr
    }}
    
    @IBInspectable
    var loi: String = "1 minutes" { didSet {
        let loiStr: String = {
            switch type {
            case .simple: return "Now in \(loi)!"
            case .compact: return loi
            case .full_width: return loi
            }
        }()
        
        loiLabel?.text = loiStr
    }}
    
    var color: [UIColor] = [.black, .black] { didSet {
        
        let usedColor: UIColor = {
            switch type {
            case .simple: return .white
            case .compact: return color.first!
            case .full_width: return .white
            }
        }()
        
        rewardLabel?.textColor = usedColor
        playImageView?.setImageColor(color: usedColor)
        
        earnNowLabel?.textColor = color.first!
        changeGradient(of: contentView, withColors: color)
    }}
    
    var type: WidgetType = .simple
    weak var parent: UIViewController?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    init(frame: CGRect, withType type: WidgetType ) {
        super.init(frame: frame)
        self.type = type
        initSubviews()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initSubviews()
    }
    
    func initSubviews() {
        let nibName: String = {
            switch type {
            case .simple: return "SimpleSurveyView"
            case .compact: return "CompactSurveyView"
            case .full_width: return "FullWidthSurveyView"
            }
        }()
        
        let nib = UINib(nibName: nibName, bundle: bundle)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    @IBAction func onPress(_ sender: Any) {
        contentView.alpha = 0.75
        UIView.animate(withDuration: 0.7) { self.contentView.alpha = 1.0 }
        BitLabs.shared.launchOfferWall(parent: parent!)
    }
    
    private func determineRating() {
        if rating >= 1 {
            star1?.image = UIImage(named: "star-solid", in: bundle, compatibleWith: nil)
        }
        if rating >= 2 {
            star2?.image = UIImage(named: "star-solid", in: bundle, compatibleWith: nil)
        }
        
        if rating >= 3 {
            star3?.image = UIImage(named: "star-solid", in: bundle, compatibleWith: nil)
        }
        
        if rating >= 4 {
            star4?.image = UIImage(named: "star-solid", in: bundle, compatibleWith: nil)
        }
        
        if rating >= 5 {
            star5?.image = UIImage(named: "star-solid", in: bundle, compatibleWith: nil)
        }
    }
}