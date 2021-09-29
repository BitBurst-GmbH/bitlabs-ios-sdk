//
//  ViewController.swift
//  BitLabs
//
//  Created by BitBurst GmbH on 11/09/2020.
//  Copyright (c) 2021 BitBurst GmbH. All rights reserved.
//

import BitLabs
import UIKit

class ViewController: UIViewController {

    let token = "97e3efee-576b-4ef5-a28c-f15065cc2938"
    let uid = "YOUR_USER_ID"
    
    var bitlabs: BitLabs?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bitlabs = BitLabs.Init(token: token, uid: uid)
        bitlabs?.setTags(t: ["userType": "New", "isPremium": false])
    }
    
    
    @IBAction func checkForSurveys( _ sender: UIButton ) {
        bitlabs?.hasSurveys() { result in
            switch result {
            case true:
                debugPrint("Surveys available!")
            case false:
                debugPrint("No surveys available!")
            }
        }
    }
    
    @IBAction func showWebView(_ sender: UIButton) {
        self.bitlabs?.show(parent: self)
    }
    
}
