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
        app.launchArguments.append("UITestingEnvironment")
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

    func test_CorrectFormURL_WebViewExists() {
        let button = app.buttons["Correct Form URL"]
        XCTAssertTrue(button.exists)
        
        button.tap()
        sleep(2)
        
        let wv = app.webViews.firstMatch
        XCTAssertTrue(wv.exists)
    }
   
    func test_TopBar_OfferwallURL_NotExists() {
        let button = app.buttons["Offerwall URL"]
        XCTAssertTrue(button.exists)
        
        button.tap()
        sleep(2)
        
        let topBarView = app.otherElements["topBarView"]
        XCTAssertFalse(topBarView.exists)
    }
    
    func test_TopBar_NotOfferwallURL_Exists() {
        let button = app.buttons["Not Offerwall URL"]
        XCTAssertTrue(button.exists)
        
        button.tap()
        sleep(2)
        
        let topBarView = app.otherElements["topBarView"]
        XCTAssertTrue(topBarView.exists)
    }
    
    func test_TopBarViewBackButton_ShowLeaveSurveyDialog() {
        let button = app.buttons["Not Offerwall URL"]
        XCTAssertTrue(button.exists)
        button.tap()
        
        sleep(2)
        
        let backButton = app.buttons["circle chevron left regular"]
        XCTAssertTrue(backButton.exists)
        backButton.tap()
        
        sleep(2)
        
        let alert = app.alerts["Leave Survey"]
        XCTAssertTrue(alert.exists)
    }
    
    func test_LeaveSurveyDialog_AnyOptionClicked_LeaveSurveyCalled() {
        let button = app.buttons["Not Offerwall URL"]
        XCTAssertTrue(button.exists)
        button.tap()
        
        sleep(1)
        
        let backButton = app.buttons["circle chevron left regular"]
        XCTAssertTrue(backButton.exists)
        backButton.tap()
        
        sleep(1)
        
        let alert = app.alerts["Leave Survey"]
        XCTAssertTrue(alert.exists)
        
        let sensitive = alert.scrollViews.otherElements.buttons["Too sensitive"]
        XCTAssertTrue(sensitive.exists)
        sensitive.tap()
        
        sleep(1)
        
        var label = app.staticTexts["Too sensitive"]
        XCTAssertTrue(label.exists)

        XCTAssertTrue(button.exists)
        button.tap()
        
        sleep(1)
        
        XCTAssertTrue(backButton.exists)
        backButton.tap()
        
        sleep(1)
        
        XCTAssertTrue(alert.exists)
        
        let uninsteresting = alert.scrollViews.otherElements.buttons["Uninteresting"]
        XCTAssertTrue(uninsteresting.exists)
        uninsteresting.tap()
        
        sleep(1)
        
        label = app.staticTexts["Uninteresting"]
        XCTAssertTrue(label.exists)
        
        XCTAssertTrue(button.exists)
        button.tap()
        
        sleep(1)
        
        XCTAssertTrue(backButton.exists)
        backButton.tap()
        
        sleep(1)
        
        XCTAssertTrue(alert.exists)
        
        let techinicalIssues = alert.scrollViews.otherElements.buttons["Technical issues"]
        XCTAssertTrue(techinicalIssues.exists)
        techinicalIssues.tap()
        
        sleep(1)
        
        label = app.staticTexts["Technical issues"]
        XCTAssertTrue(label.exists)
        
        XCTAssertTrue(button.exists)
        button.tap()
        
        sleep(1)
        
        XCTAssertTrue(backButton.exists)
        backButton.tap()
        
        sleep(1)
        
        XCTAssertTrue(alert.exists)
        
        let tooLong = alert.scrollViews.otherElements.buttons["Too long"]
        XCTAssertTrue(tooLong.exists)
        tooLong.tap()
        
        sleep(1)
        
        label = app.staticTexts["Too long"]
        XCTAssertTrue(label.exists)
        
        XCTAssertTrue(button.exists)
        button.tap()
        
        sleep(1)
        
        XCTAssertTrue(backButton.exists)
        backButton.tap()
        
        sleep(1)
        
        XCTAssertTrue(alert.exists)
        
        let other = alert.scrollViews.otherElements.buttons["Other Reason"]
        XCTAssertTrue(other.exists)
        other.tap()
        
        sleep(1)
        
        label = app.staticTexts["Other Reason"]
        XCTAssertTrue(label.exists)
    }
}
