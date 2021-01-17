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

    let token = "6c7083df-b97e-4d29-9d90-798fd088bc08"
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
    }
    
    
    @IBAction func checkForSurveys( _ sender: UIButton ) {
        bitlabs?.checkForSurveys() { result in
            switch result {
            case .success(let result):
                if (result.hasSurveys) {
                    debugPrint("Surveys available!")
                } else {
                    debugPrint("No surveys available!")
                }
            case .failure(let error):
                debugPrint(error)
            }
            
        }
    }
    
    @IBAction func showWebView(_ sender: UIButton) {
        self.bitlabs?.show(parent: self)
    }
    
}
