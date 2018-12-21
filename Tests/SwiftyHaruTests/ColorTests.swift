//
//  ColorTests.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 03.10.16.
//
//

import XCTest
@testable import SwiftyHaru

final class ColorTests: XCTestCase {

    static let allTests = [
        ("testInitializeRGBColor", testInitializeRGBColor),
        ("testInitializeCMYKColor", testInitializeCMYKColor),
        ("testInitializeFromColorLiteral", testInitializeFromColorLiteral),
        ("testInitializeGrayColor", testInitializeGrayColor),
        ("testGetComponentsForRGBColor", testGetComponentsForRGBColor),
        ("testGetComponentsForCMYKColor", testGetComponentsForCMYKColor),
        ("testGetComponentsForGrayColor", testGetComponentsForGrayColor),
        ("testSetComponentsForRGBColor", testSetComponentsForRGBColor),
        ("testSetComponentsForCMYKColor", testSetComponentsForCMYKColor),
        ("testSetComponentsForGrayColor", testSetComponentsForGrayColor),
        ("testConvertingFromRGBToCMYK", testConvertingFromRGBToCMYK),
        ("testConvertingFromCMYKToRGB", testConvertingFromCMYKToRGB)
    ]
    
    static let colorComparisonAccuracy: Float = 0.00390625 // 1/256 — enough accuracy
    
    func testInitializeRGBColor() {
        
        // Given
        let expectedRed: Float = 0.25
        let expectedGreen: Float = 0.47
        let expectedBlue: Float = 0.1
        let expectedAlpha: Float = 0.75
        
        // When
        guard let color = Color(red: 0.25, green: 0.47, blue: 0.1, alpha: 0.75) else {
            XCTFail("The color must be initialized")
            return
        }
        
        // Then
        guard case .rgb(let returnedColor) = color._wrapped else {
            XCTFail("The RGB color must be initialized")
            return
        }
        
        XCTAssertEqual(expectedRed, returnedColor.red)
        XCTAssertEqual(expectedGreen, returnedColor.green)
        XCTAssertEqual(expectedBlue, returnedColor.blue)
        XCTAssertEqual(expectedAlpha, color.alpha)
        XCTAssertEqual(color.colorSpace, .deviceRGB)
    }
    
    func testInitializeCMYKColor() {
        
        // Given
        let expectedCyan: Float = 0.25
        let expectedMagenta: Float = 0.47
        let expectedYellow: Float = 0.1
        let expectedBlack: Float = 0.5
        let expectedAlpha: Float = 0.75
        
        // When
        guard let color = Color(cyan: 0.25, magenta: 0.47, yellow: 0.1, black: 0.5, alpha: 0.75) else {
            XCTFail("The color must be initialized")
            return
        }
        
        // Then
        guard case .cmyk(let returnedColor) = color._wrapped else {
            XCTFail("The CMYK color must be initialized")
            return
        }
        
        XCTAssertEqual(expectedCyan, returnedColor.cyan)
        XCTAssertEqual(expectedMagenta, returnedColor.magenta)
        XCTAssertEqual(expectedYellow, returnedColor.yellow)
        XCTAssertEqual(expectedBlack, returnedColor.black)
        XCTAssertEqual(expectedAlpha, color.alpha)
        XCTAssertEqual(color.colorSpace, .deviceCMYK)
    }
    
    func testInitializeGrayColor() {
        
        // Given
        let expectedGray: Float = 0.33
        let expectedAlpha: Float = 0.75
        
        // When
        guard let color = Color(gray: 0.33, alpha: 0.75) else {
            XCTFail("The color must be initialized")
            return
        }
        
        // Then
        guard case .gray(let returnedColor) = color._wrapped else {
            XCTFail("The gray color must be initialized")
            return
        }
        
        XCTAssertEqual(expectedGray, returnedColor)
        XCTAssertEqual(expectedAlpha, color.alpha)
        XCTAssertEqual(color.colorSpace, .deviceGray)
    }
    
    func testInitializeFromColorLiteral() {
        
        // Given
        let colorFromInit = Color(red: 0.25, green: 0.47, blue: 0.1, alpha: 0.75)
        
        // When
        let colorFromLiteral: Color = #colorLiteral(red: 0.25, green: 0.47, blue: 0.1, alpha: 0.75)
        
        // Then
        XCTAssertEqual(colorFromLiteral, colorFromInit)
    }
    
    func testGetComponentsForRGBColor() {
        
        // Given
        let expectedRed: Float = 0.12
        let expectedGreen: Float = 0.23
        let expectedBlue: Float = 0.34
        let expectedCyan: Float = 0.644
        let expectedMagenta: Float = 0.322
        let expectedYellow: Float = 0.0
        let expectedBlack: Float = 0.659
        let color = Color(red: 0.12, green: 0.23, blue: 0.34)
        
        // When
        let returnedRed = color?.red ?? -1
        let returnedGreen = color?.green ?? -1
        let returnedBlue = color?.blue ?? -1
        let returnedCyan = color?.cyan ?? -1
        let returnedMagenta = color?.magenta ?? -1
        let returnedYellow = color?.yellow ?? -1
        let returnedBlack = color?.black ?? -1

        // Then
        XCTAssertEqual(expectedRed, returnedRed)
        XCTAssertEqual(expectedGreen, returnedGreen)
        XCTAssertEqual(expectedBlue, returnedBlue)
        XCTAssertEqual(expectedCyan, returnedCyan, accuracy: ColorTests.colorComparisonAccuracy)
        XCTAssertEqual(expectedMagenta, returnedMagenta, accuracy: ColorTests.colorComparisonAccuracy)
        XCTAssertEqual(expectedYellow, returnedYellow, accuracy: ColorTests.colorComparisonAccuracy)
        XCTAssertEqual(expectedBlack, returnedBlack, accuracy: ColorTests.colorComparisonAccuracy)
    }
    
    func testGetComponentsForCMYKColor() {
        
        // Given
        let expectedRed: Float = 0.12
        let expectedGreen: Float = 0.23
        let expectedBlue: Float = 0.34
        let expectedCyan: Float = 0.644
        let expectedMagenta: Float = 0.322
        let expectedYellow: Float = 0.0
        let expectedBlack: Float = 0.659
        let color = Color(cyan: 0.644, magenta: 0.322, yellow: 0.0, black: 0.659)
        
        // When
        let returnedRed = color?.red ?? -1
        let returnedGreen = color?.green ?? -1
        let returnedBlue = color?.blue ?? -1
        let returnedCyan = color?.cyan ?? -1
        let returnedMagenta = color?.magenta ?? -1
        let returnedYellow = color?.yellow ?? -1
        let returnedBlack = color?.black ?? -1
        
        // Then
        XCTAssertEqual(expectedCyan, returnedCyan)
        XCTAssertEqual(expectedMagenta, returnedMagenta)
        XCTAssertEqual(expectedYellow, returnedYellow)
        XCTAssertEqual(expectedBlack, returnedBlack)
        XCTAssertEqual(expectedRed, returnedRed, accuracy: ColorTests.colorComparisonAccuracy)
        XCTAssertEqual(expectedGreen, returnedGreen, accuracy: ColorTests.colorComparisonAccuracy)
        XCTAssertEqual(expectedBlue, returnedBlue, accuracy: ColorTests.colorComparisonAccuracy)
    }
    
    func testGetComponentsForGrayColor() {
        
        // Given
        let expectedRed: Float = 0.57
        let expectedGreen: Float = 0.57
        let expectedBlue: Float = 0.57
        let expectedCyan: Float = 0.0
        let expectedMagenta: Float = 0.0
        let expectedYellow: Float = 0.0
        let expectedBlack: Float = 0.57
        let color = Color(gray: 0.57)
        
        // When
        let returnedRed = color?.red ?? -1
        let returnedGreen = color?.green ?? -1
        let returnedBlue = color?.blue ?? -1
        let returnedCyan = color?.cyan ?? -1
        let returnedMagenta = color?.magenta ?? -1
        let returnedYellow = color?.yellow ?? -1
        let returnedBlack = color?.black ?? -1
        
        // Then
        XCTAssertEqual(expectedRed, returnedRed)
        XCTAssertEqual(expectedGreen, returnedGreen)
        XCTAssertEqual(expectedBlue, returnedBlue)
        XCTAssertEqual(expectedCyan, returnedCyan)
        XCTAssertEqual(expectedMagenta, returnedMagenta)
        XCTAssertEqual(expectedYellow, returnedYellow)
        XCTAssertEqual(expectedBlack, returnedBlack)
    }
    
    func testSetComponentsForRGBColor() {
        
        // Given
        let initialColor = Color(red: 1, green: 1, blue: 1)
        let expectedColorChangedRed = Color(red: 0.5, green: 1, blue: 1)
        let expectedColorChangedGreen = Color(red: 1, green: 0.5, blue: 1)
        let expectedColorChangedBlue = Color(red: 1, green: 1, blue: 0.5)
        let expectedColorChangedCyan = Color(red: 0.5019, green: 1, blue: 1)
        let expectedColorChangedMagenta = Color(red: 1, green: 0.5019, blue: 1)
        let expectedColorChangedYellow = Color(red: 1, green: 1, blue: 0.5019)
        let expectedColorChangedBlack = Color(red: 0.5019, green: 0.5019, blue: 0.5019)
        
        // When
        var actualColorChangedRed = initialColor
        actualColorChangedRed?.red = 0.5
        
        // Then
        XCTAssertEqual(expectedColorChangedRed, actualColorChangedRed)
        
        // When
        var actualColorChangedGreen = initialColor
        actualColorChangedGreen?.green = 0.5
        
        // Then
        XCTAssertEqual(expectedColorChangedGreen, actualColorChangedGreen)
        
        // When
        var actualColorChangedBlue = initialColor
        actualColorChangedBlue?.blue = 0.5
        
        // Then
        XCTAssertEqual(expectedColorChangedBlue, actualColorChangedBlue)
        
        // When
        var actualColorChangedCyan = initialColor
        actualColorChangedCyan?.cyan = 0.5
        
        // Then
        XCTAssertEqual(expectedColorChangedCyan!.red,
                       actualColorChangedCyan!.red,
                       accuracy: ColorTests.colorComparisonAccuracy)
        XCTAssertEqual(expectedColorChangedCyan!.green,
                       actualColorChangedCyan!.green,
                       accuracy: ColorTests.colorComparisonAccuracy)
        XCTAssertEqual(expectedColorChangedCyan!.blue,
                       actualColorChangedCyan!.blue,
                       accuracy: ColorTests.colorComparisonAccuracy)
        
        // When
        var actualColorChangedMagenta = initialColor
        actualColorChangedMagenta?.magenta = 0.5
        
        // Then
        XCTAssertEqual(expectedColorChangedMagenta!.red,
                       actualColorChangedMagenta!.red,
                       accuracy: ColorTests.colorComparisonAccuracy)
        XCTAssertEqual(expectedColorChangedMagenta!.green,
                       actualColorChangedMagenta!.green,
                       accuracy: ColorTests.colorComparisonAccuracy)
        XCTAssertEqual(expectedColorChangedMagenta!.blue,
                       actualColorChangedMagenta!.blue,
                       accuracy: ColorTests.colorComparisonAccuracy)
        
        // When
        var actualColorChangedYellow = initialColor
        actualColorChangedYellow?.yellow = 0.5
        
        // Then
        XCTAssertEqual(expectedColorChangedYellow!.red,
                       actualColorChangedYellow!.red,
                       accuracy: ColorTests.colorComparisonAccuracy)
        XCTAssertEqual(expectedColorChangedYellow!.green,
                       actualColorChangedYellow!.green,
                       accuracy: ColorTests.colorComparisonAccuracy)
        XCTAssertEqual(expectedColorChangedYellow!.blue,
                       actualColorChangedYellow!.blue,
                       accuracy: ColorTests.colorComparisonAccuracy)
        
        // When
        var actualColorChangedBlack = initialColor
        actualColorChangedBlack?.black = 0.5
        
        // Then
        XCTAssertEqual(expectedColorChangedBlack!.red,
                       actualColorChangedBlack!.red,
                       accuracy: ColorTests.colorComparisonAccuracy)
        XCTAssertEqual(expectedColorChangedBlack!.green,
                       actualColorChangedBlack!.green,
                       accuracy: ColorTests.colorComparisonAccuracy)
        XCTAssertEqual(expectedColorChangedBlack!.blue,
                       actualColorChangedBlack!.blue,
                       accuracy: ColorTests.colorComparisonAccuracy)
    }
    
    func testSetComponentsForCMYKColor() {
        
        // Given
        let initialColor = Color(cyan: 0, magenta: 0, yellow: 0, black: 0)
        let expectedColorChangedCyan = Color(cyan: 0.5, magenta: 0, yellow: 0, black: 0)
        let expectedColorChangedMagenta = Color(cyan: 0, magenta: 0.5, yellow: 0, black: 0)
        let expectedColorChangedYellow = Color(cyan: 0, magenta: 0, yellow: 0.5, black: 0)
        let expectedColorChangedBlack = Color(cyan: 0, magenta: 0, yellow: 0, black: 0.5)
        let expectedColorChangedRed = Color(cyan: 0.5, magenta: 0, yellow: 0, black: 0)
        let expectedColorChangedGreen = Color(cyan: 0, magenta: 0.5, yellow: 0, black: 0)
        let expectedColorChangedBlue = Color(cyan: 0, magenta: 0, yellow: 0.5, black: 0)
        
        // When
        var actualColorChangedCyan = initialColor
        actualColorChangedCyan?.cyan = 0.5
        
        // Then
        XCTAssertEqual(expectedColorChangedCyan, actualColorChangedCyan)
        
        // When
        var actualColorChangedMagenta = initialColor
        actualColorChangedMagenta?.magenta = 0.5
        
        // Then
        XCTAssertEqual(expectedColorChangedMagenta, actualColorChangedMagenta)
        
        // When
        var actualColorChangedYellow = initialColor
        actualColorChangedYellow?.yellow = 0.5
        
        // Then
        XCTAssertEqual(expectedColorChangedYellow, actualColorChangedYellow)
        
        // When
        var actualColorChangedBlack = initialColor
        actualColorChangedBlack?.black = 0.5
        
        // Then
        XCTAssertEqual(expectedColorChangedBlack, actualColorChangedBlack)
        
        // When
        var actualColorChangedRed = initialColor
        actualColorChangedRed?.red = 0.5
        
        // Then
        XCTAssertEqual(expectedColorChangedRed!.cyan,
                       actualColorChangedRed!.cyan,
                       accuracy: ColorTests.colorComparisonAccuracy)
        XCTAssertEqual(expectedColorChangedRed!.magenta,
                       actualColorChangedRed!.magenta,
                       accuracy: ColorTests.colorComparisonAccuracy)
        XCTAssertEqual(expectedColorChangedRed!.yellow,
                       actualColorChangedRed!.yellow,
                       accuracy: ColorTests.colorComparisonAccuracy)
        XCTAssertEqual(expectedColorChangedRed!.black,
                       actualColorChangedRed!.black,
                       accuracy: ColorTests.colorComparisonAccuracy)
        
        // When
        var actualColorChangedGreen = initialColor
        actualColorChangedGreen?.green = 0.5
        
        // Then
        XCTAssertEqual(expectedColorChangedGreen!.cyan,
                       actualColorChangedGreen!.cyan,
                       accuracy: ColorTests.colorComparisonAccuracy)
        XCTAssertEqual(expectedColorChangedGreen!.magenta,
                       actualColorChangedGreen!.magenta,
                       accuracy: ColorTests.colorComparisonAccuracy)
        XCTAssertEqual(expectedColorChangedGreen!.yellow,
                       actualColorChangedGreen!.yellow,
                       accuracy: ColorTests.colorComparisonAccuracy)
        XCTAssertEqual(expectedColorChangedGreen!.black,
                       actualColorChangedGreen!.black,
                       accuracy: ColorTests.colorComparisonAccuracy)
        
        // When
        var actualColorChangedBlue = initialColor
        actualColorChangedBlue?.blue = 0.5
        
        // Then
        XCTAssertEqual(expectedColorChangedBlue!.cyan,
                       actualColorChangedBlue!.cyan,
                       accuracy: ColorTests.colorComparisonAccuracy)
        XCTAssertEqual(expectedColorChangedBlue!.magenta,
                       actualColorChangedBlue!.magenta,
                       accuracy: ColorTests.colorComparisonAccuracy)
        XCTAssertEqual(expectedColorChangedBlue!.yellow,
                       actualColorChangedBlue!.yellow,
                       accuracy: ColorTests.colorComparisonAccuracy)
        XCTAssertEqual(expectedColorChangedBlue!.black,
                       actualColorChangedBlue!.black,
                       accuracy: ColorTests.colorComparisonAccuracy)
    }
    
    func testSetComponentsForGrayColor() {
        
        // Given
        let initialColor = Color(gray: 0)
        let expectedColorChangedCyan = Color(gray: 0)
        let expectedColorChangedMagenta = Color(gray: 0)
        let expectedColorChangedYellow = Color(gray: 0)
        let expectedColorChangedBlack = Color(gray: 0.5)
        let expectedColorChangedRed = Color(gray: 0.5)
        let expectedColorChangedGreen = Color(gray: 0.5)
        let expectedColorChangedBlue = Color(gray: 0.5)
        
        // When
        var actualColorChangedCyan = initialColor
        actualColorChangedCyan?.cyan = 0.5
        
        // Then
        XCTAssertEqual(expectedColorChangedCyan, actualColorChangedCyan)
        
        // When
        var actualColorChangedMagenta = initialColor
        actualColorChangedMagenta?.magenta = 0.5
        
        // Then
        XCTAssertEqual(expectedColorChangedMagenta, actualColorChangedMagenta)
        
        // When
        var actualColorChangedYellow = initialColor
        actualColorChangedYellow?.yellow = 0.5
        
        // Then
        XCTAssertEqual(expectedColorChangedYellow, actualColorChangedYellow)
        
        // When
        var actualColorChangedBlack = initialColor
        actualColorChangedBlack?.black = 0.5
        
        // Then
        XCTAssertEqual(expectedColorChangedBlack, actualColorChangedBlack)
        
        // When
        var actualColorChangedRed = initialColor
        actualColorChangedRed?.red = 0.5
        
        // Then
        XCTAssertEqual(expectedColorChangedRed, actualColorChangedRed)
        
        // When
        var actualColorChangedGreen = initialColor
        actualColorChangedGreen?.green = 0.5
        
        // Then
        XCTAssertEqual(expectedColorChangedGreen, actualColorChangedGreen)
        
        // When
        var actualColorChangedBlue = initialColor
        actualColorChangedBlue?.blue = 0.5
        
        // Then
        XCTAssertEqual(expectedColorChangedBlue, actualColorChangedBlue)
    }
    
    func testConvertingFromRGBToCMYK() {
        
        // Given
        let initialRGBColor = Color(red: 0.12, green: 0.23, blue: 0.34)
        let expectedCyan: Float = 0.644
        let expectedMagenta: Float = 0.322
        let expectedYellow: Float = 0.0
        let expectedBlack: Float = 0.659
        
        // When
        guard let returnedCMYKColor = initialRGBColor?.converting(to: .deviceCMYK) else {
            XCTFail("The color must be initialized")
            return
        }
        
        // Then
        guard case .cmyk(let actualColor) = returnedCMYKColor._wrapped else {
            XCTFail("The color should be converted to CMYK space")
            return
        }
        
        XCTAssertEqual(expectedCyan,
                       actualColor.cyan,
                       accuracy: ColorTests.colorComparisonAccuracy)
        XCTAssertEqual(expectedMagenta,
                       actualColor.magenta,
                       accuracy: ColorTests.colorComparisonAccuracy)
        XCTAssertEqual(expectedYellow,
                       actualColor.yellow,
                       accuracy: ColorTests.colorComparisonAccuracy)
        XCTAssertEqual(expectedBlack,
                       actualColor.black,
                       accuracy: ColorTests.colorComparisonAccuracy)
        XCTAssertEqual(returnedCMYKColor.colorSpace, .deviceCMYK)
    }
    
    func testConvertingFromCMYKToRGB() {
        
        // Given
        let initialCMYKColor = Color(cyan: 0.644, magenta: 0.322, yellow: 0.0, black: 0.659)
        let expectedRed: Float = 0.12
        let expectedGreen: Float = 0.23
        let expectedBlue: Float = 0.34

        // When
        guard let returnedRGBColor = initialCMYKColor?.converting(to: .deviceRGB) else {
            XCTFail("The color must be initialized")
            return
        }
        
        // Then
        guard case .rgb(let actualColor) = returnedRGBColor._wrapped else {
            XCTFail("The color should be converted to CMYK space")
            return
        }
        
        XCTAssertEqual(expectedRed,
                       actualColor.red,
                       accuracy: ColorTests.colorComparisonAccuracy)
        XCTAssertEqual(expectedGreen,
                       actualColor.green,
                       accuracy: ColorTests.colorComparisonAccuracy)
        XCTAssertEqual(expectedBlue,
                       actualColor.blue,
                       accuracy: ColorTests.colorComparisonAccuracy)
        XCTAssertEqual(returnedRGBColor.colorSpace, .deviceRGB)
    }
}
