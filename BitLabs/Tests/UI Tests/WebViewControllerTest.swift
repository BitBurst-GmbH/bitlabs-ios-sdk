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
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        app.launch()
    }
    
    func test_NoURL_WebViewClosed() {
        let button = app.buttons["No URL"]
        XCTAssertTrue(button.exists)
        
        button.tap()
        sleep(2)
        
        let wv = app.webViews.firstMatch
        XCTAssertFalse(wv.exists)
    }
    
    func test_EmptyURL_WebViewClosed() {
        let button = app.buttons["Empty URL"]
        XCTAssertTrue(button.exists)
        
        button.tap()
        sleep(2)
        
        let wv = app.webViews.firstMatch
        XCTAssertFalse(wv.exists)
    }
    
    func test_IncorrectURL_WebViewClosed() {
        let button = app.buttons["Incorrect URL"]
        XCTAssertTrue(button.exists)
        
        button.tap()
        sleep(2)
        
        let wv = app.webViews.firstMatch
        XCTAssertFalse(wv.exists)
    }
    
    func test_CorrectFormURL_WebViewExists() {
        let button = app.buttons["Correct Form URL"]
        XCTAssertTrue(button.exists)
        
        button.tap()
        sleep(2)
        
        let wv = app.webViews.firstMatch
        XCTAssertTrue(wv.exists)
    }
   
    func test_TopBar_NotOfferwall_Exists() {
        let button = app.buttons["No URL"]
        XCTAssertTrue(button.exists)
        
        button.tap()
        
        let topBarView = app.otherElements["topBarView"]
        XCTAssertTrue(topBarView.exists)
    }
}
