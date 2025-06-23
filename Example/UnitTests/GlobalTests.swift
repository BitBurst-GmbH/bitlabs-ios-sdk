//
//  GlobalTests.swift
//  GlobalTests
//
//  Created by Omar Raad on 02.10.23.
//

import XCTest
@testable import BitLabs

class GlobalTests: XCTestCase {
    
    func testGetLuminance_ColorBlack_0() {
        let color = UIColor.black
        let expected = 0.0
        
        let luminance = color.luminance
        
        XCTAssertEqual(luminance, expected)
    }
    
    func testGetLuminance_ColorWhite_1() {
        let color = UIColor.white
        let expected = 1.0
        
        let luminance = color.luminance
        
        XCTAssertEqual(luminance, expected)
    }
    
    func testExtractColors_SingleHexColor_TwoColors() {
        let color = "#FFFFFF"
        let expected = [color, color]
        
        let colors = color.extractColors
        
        XCTAssertEqual(colors, expected)
    }
    
    func testExtractColors_LinearGradient_TwoColors() {
        let color = "linear-gradient(90deg, #FFFFFF 0%, #000000 100%)"
        let expected = ["#FFFFFF", "#000000"]
        
        let colors = color.extractColors
        
        XCTAssertEqual(colors, expected)
    }
    
    func testExtractColors_EmptyString_EmptyArray() {
        let color = ""
        let expected: [String] = []
        
        let colors = color.extractColors
        
        XCTAssertEqual(colors, expected)
    }
    
    func testExtractColors_NonColorOrGradient_EmptyArray() {
        let color = "A String that isn't a color or gradient"
        let expected: [String] = []
        
        let colors = color.extractColors

        XCTAssertEqual(colors, expected)
    }
    
    func testToUIColor_WhiteHex_WhiteColor() {
        let hex = "#FFFFFF"
        let expected = UIColor.white
                
        let color = hex.toUIColor
                
        // The conversion is important to compare colors in the same colorspace
        XCTAssertEqual(
            color?.cgColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil),
            expected.cgColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
        )
    }
    
    func testToUIColor_BlackHex_BlackColor() {
        let hex = "#000000"
        let expected = UIColor.black
        
        let color = hex.toUIColor
        
        // The conversion is important to compare colors in the same colorspace
        XCTAssertEqual(
            color?.cgColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil),
            expected.cgColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
        )
    }
    
    func testToUIColor_EmptyString_nil() {
        let hex = ""
        let expected: UIColor? = nil
        
        let color = hex.toUIColor
        
        // The conversion is important to compare colors in the same colorspace
        XCTAssertEqual(
            color?.cgColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil),
            expected?.cgColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
        )
    }
    
    func testToUIColor_NonHexString_nil() {
        let hex = "String that isn't a valid Hex"
        let expected: UIColor? = nil
        
        let color = hex.toUIColor
        
        // The conversion is important to compare colors in the same colorspace
        XCTAssertEqual(
            color?.cgColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil),
            expected?.cgColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
        )
    }
}
