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
    
    /// Helper function to wait for an element to exist
    private func waitFor(element: XCUIElement, timeout: TimeInterval = 5) -> Bool {
        let exists = NSPredicate(format: "exists == true")
        let expectation = XCTNSPredicateExpectation(predicate: exists, object: element)
        return XCTWaiter().wait(for: [expectation], timeout: timeout) == .completed
    }
    
    func test_NoURL_WebViewClosed() {
        let button = app.buttons["No URL"]
        XCTAssertTrue(button.exists)
        
        button.tap()
        
        let wv = app.webViews.firstMatch
        XCTAssertFalse(waitFor(element: wv), "WebView should not exist for 'No URL' scenario")
    }
    
    func test_EmptyURL_WebViewClosed() {
        let button = app.buttons["Empty URL"]
        XCTAssertTrue(button.exists)
        
        button.tap()
        
        let wv = app.webViews.firstMatch
        XCTAssertFalse(waitFor(element: wv), "WebView should not exist for 'Empty URL' scenario")
    }
    
    func test_CorrectFormURL_WebViewExists() {
        let button = app.buttons["Correct Form URL"]
        XCTAssertTrue(button.exists)
        
        button.tap()
        
        let wv = app.webViews.firstMatch
        XCTAssertTrue(waitFor(element: wv), "WebView should exist for 'Correct Form URL' scenario")
    }
    
    func test_TopBar_OfferwallURL_NotExists() {
        let button = app.buttons["Offerwall URL"]
        XCTAssertTrue(button.exists)
        
        button.tap()
        
        let topBarView = app.otherElements["topBarView"]
        XCTAssertFalse(waitFor(element: topBarView), "TopBarView should not exist when URL is OfferWall")
    }
    
    func test_TopBar_NotOfferwallURL_Exists() {
        let button = app.buttons["Not Offerwall URL"]
        XCTAssertTrue(button.exists)
        
        button.tap()
        
        let topBarView = app.otherElements["topBarView"]
        XCTAssertTrue(waitFor(element: topBarView), "TopBarView should exist when URL is not OfferWall")
    }
    
    func test_TopBarViewBackButton_ShowLeaveSurveyDialog() {
        let button = app.buttons["Not Offerwall URL"]
        XCTAssertTrue(button.exists)
        button.tap()
                
        let backButton = app.buttons["circle chevron left regular"]
        XCTAssertTrue(waitFor(element: backButton), "Back button should appear")
        backButton.tap()
                
        let alert = app.alerts["Leave Survey"]
        XCTAssertTrue(waitFor(element: alert), "Leave Survey alert should appear")
    }
    
    func test_LeaveSurveyDialog_AnyOptionClicked_LeaveSurveyCalled() {
        let button = app.buttons["Not Offerwall URL"]
        XCTAssertTrue(button.exists, "Not Offerwall URL button should exist")
        button.tap()
        
        func tapBackButtonAndVerify() {
            let backButton = app.buttons["circle chevron left regular"]
            XCTAssertTrue(waitFor(element: backButton), "Back button should appear")
            backButton.tap()
        }
        
        func verifyAlertAndTap(option: String) {
            let alert = app.alerts["Leave Survey"]
            XCTAssertTrue(waitFor(element: alert), "Leave Survey alert should appear")
            
            let optionButton = alert.scrollViews.otherElements.buttons[option]
            XCTAssertTrue(optionButton.exists, "\(option) option should exist")
            optionButton.tap()
        }
        
        func verifyLabel(_ labelName: String) {
            let label = app.staticTexts[labelName]
            XCTAssertTrue(waitFor(element: label), "Label '\(labelName)' should exist")
        }
        
        let options = [
            "Too sensitive",
            "Uninteresting",
            "Technical issues",
            "Too long",
            "Other Reason"
        ]
        
        for option in options {
            
            // Tap the back button and verify its appearance
            tapBackButtonAndVerify()
            
            // Verify the alert is present and tap the specific survey option
            verifyAlertAndTap(option: option)
            
            // Verify that the appropriate label is displayed after the selection
            verifyLabel(option)
            
            // Re-tap the "Not Offerwall URL" button to reset the state for the next iteration
            XCTAssertTrue(button.exists, "Not Offerwall URL button should exist")
            button.tap()
        }
    }
}
