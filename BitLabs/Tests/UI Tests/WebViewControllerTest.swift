//
//  WebViewControllerTest.swift
//  BitLabs-Unit-Tests
//
//  Created by Omar Raad on 17.10.23.
//

import Foundation
import XCTest
@testable import BitLabs

class WebViewControllerTest: XCTestCase {
    
    override func setUpWithError() throws {
        
    }
   
    func testLaunch() {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["Open Webview"].staticTexts["Open Webview"].tap()
    }
}
