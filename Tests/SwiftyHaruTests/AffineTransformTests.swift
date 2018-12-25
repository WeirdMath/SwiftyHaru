//
//  AffineTransformTests.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 25/06/2017.
//
//

import XCTest
import SwiftyHaru

final class AffineTransformTests: TestCase {
    
    static let allTests = [
        ("testAffineTransformDescription", testAffineTransformDescription),
        ("testMakeRotation", testMakeRotation),
        ("testMakeScale", testMakeScale),
        ("testMakeTranslation", testMakeTranslation),
        ("testConcatenate", testConcatenate),
        ("testInvert", testInvert),
        ("testConcatenateWithRotation", testConcatenateWithRotation),
        ("testConcatenateWithScaling", testConcatenateWithScaling),
        ("testConcatenateWithTranslation", testConcatenateWithTranslation),
        ("testApplyTransformToSize", testApplyTransformToSize),
        ("testApplyTransformToPoint", testApplyTransformToPoint)
    ]

    func testAffineTransformDescription() {
        
        // Given
        let transform = AffineTransform(a:  200,    b:  1,
                                        c:  12.333, d:  -3,
                                        tx: 0,      ty: 1223)
        let expectedRepresentation = """
        / 200.0  1.0    0 \\
        | 12.333 -3.0   0 |
        \\ 0.0    1223.0 1 /
        
        """
        
        // When
        let returnedRepresentation = transform.description
        
        // Then
        XCTAssertEqual(expectedRepresentation, returnedRepresentation)
    }
    
    func testMakeRotation() {
        
        // Given
        let expectedTransform1 = AffineTransform(a:  -0.903692185, b:  -0.428182662,
                                                 c:  0.428182662,  d:  -0.903692185,
                                                 tx: 0,            ty: 0)
        
        let expectedTransform2 = AffineTransform(a:  1, b:  0,
                                                 c:  0, d:  1,
                                                 tx: 0, ty: 0)
        
        let expectedTransform3 = AffineTransform(a:  1,                 b:  -0.000000301991605,
                                                 c:  0.000000301991605, d:  1,
                                                 tx: 0,                 ty: 0)
        
        let expectedTransform4 = AffineTransform(a:  0.50000006,  b:  -0.866025388,
                                                 c:  0.866025388, d:  0.50000006,
                                                 tx: 0,           ty: 0)
        
        // When
        let returnedTransform1 = AffineTransform(rotationAngle: 35)
        let returnedTransform2 = AffineTransform(rotationAngle: 0)
        let returnedTransform3 = AffineTransform(rotationAngle: 2 * .pi)
        let returnedTransform4 = AffineTransform(rotationAngle: -.pi / 3)
        
        // Then
        XCTAssertEqual(expectedTransform1, returnedTransform1)
        XCTAssertEqual(expectedTransform2, returnedTransform2)
        XCTAssertEqual(expectedTransform3, returnedTransform3)
        XCTAssertEqual(expectedTransform4, returnedTransform4)

        XCTAssertEqual(returnedTransform1.determinant, 1, accuracy: 0.0001)
        XCTAssertEqual(returnedTransform2.determinant, 1, accuracy: 0.0001)
        XCTAssertEqual(returnedTransform3.determinant, 1, accuracy: 0.0001)
        XCTAssertEqual(returnedTransform4.determinant, 1, accuracy: 0.0001)
    }
    
    func testMakeScale() {
        
        // Given
        let expectedTransform1 = AffineTransform(a:  2, b:  0,
                                                 c:  0, d:  3,
                                                 tx: 0, ty: 0)
        
        let expectedTransform2 = AffineTransform(a:  0, b:  0,
                                                 c:  0, d:  0,
                                                 tx: 0, ty: 0)
        
        let expectedTransform3 = AffineTransform(a:  -1, b:  0,
                                                 c:  0,  d:  1,
                                                 tx: 0,  ty: 0)
        
        // When
        let returnedTransform1 = AffineTransform(scaleX: 2, y: 3)
        let returnedTransform2 = AffineTransform(scaleX: 0, y: 0)
        let returnedTransform3 = AffineTransform(scaleX: -1, y: 1)
        let returnedTransform4 = AffineTransform(scaleX: 1, y: 1)
        
        // Then
        XCTAssertEqual(expectedTransform1, returnedTransform1)
        XCTAssertEqual(expectedTransform2, returnedTransform2)
        XCTAssertEqual(expectedTransform3, returnedTransform3)
        XCTAssertTrue(returnedTransform4.isIdentity)

        XCTAssertEqual(returnedTransform1.determinant, 6,  accuracy: 0.0001)
        XCTAssertEqual(returnedTransform2.determinant, 0,  accuracy: 0.0001)
        XCTAssertEqual(returnedTransform3.determinant, -1, accuracy: 0.0001)
        XCTAssertEqual(returnedTransform4.determinant, 1,  accuracy: 0.0001)
    }
    
    func testMakeTranslation() {
        
        // Given
        let expectedTransform1 = AffineTransform(a:  1,  b:  0,
                                                 c:  0,  d:  1,
                                                 tx: 12, ty: 43)
        
        let expectedTransform2 = SwiftyHaru.AffineTransform.identity
        
        let expectedTransform3 = AffineTransform(a:  1, b:  0,
                                                 c:  0, d:  1,
                                                 tx: -4, ty: 15)
        
        // When
        let returnedTransform1 = AffineTransform(translationX: 12, y: 43)
        let returnedTransform2 = AffineTransform(translationX: 0,  y: 0)
        let returnedTransform3 = AffineTransform(translationX: -4, y: 15)
        
        // Then
        XCTAssertEqual(expectedTransform1, returnedTransform1)
        XCTAssertEqual(expectedTransform2, returnedTransform2)
        XCTAssertEqual(expectedTransform3, returnedTransform3)
    }
    
    func testConcatenate() {
        
        // Given
        let transform11 = AffineTransform(a:  1,  b:  5,
                                          c:  4,  d:  6,
                                          tx: 12, ty: 43)
        
        let transform12 = AffineTransform(a:  76, b:  4,
                                          c:  8,  d:  51,
                                          tx: 0,  ty: 2)
        
        let expectedTransform1 = AffineTransform(a:  116,  b:  259,
                                                 c:  352,  d:  322,
                                                 tx: 1256, ty: 2243)
        
        let expectedTransform2 = AffineTransform(a:  4,  b:  5,
                                                 c:  9,  d:  11,
                                                 tx: 44, ty: 2)
        
        // When
        let returnedTransform1 = transform11 * transform12
        let returnedTransform2 = expectedTransform2 * .identity
        
        // Then
        XCTAssertEqual(expectedTransform1, returnedTransform1)
        XCTAssertEqual(expectedTransform2, returnedTransform2)
    }
    
    func testInvert() {
        
        // Given
        let transform1 = AffineTransform(a:  1,  b:  5,
                                         c:  4,  d:  6,
                                         tx: 12, ty: 43)
        
        
        let expectedTransform1 = AffineTransform(a:  -0.428571428571429, b:  0.357142857142857,
                                                 c:  0.285714285714286,  d:  -0.0714285714285714,
                                                 tx: -7.14285714285714,  ty: -1.21428571428571)

        let expectedTransform2 = AffineTransform(a:  3,          b:  0,
                                                 c:  4.99999952, d:  2,
                                                 tx: 9.99999904, ty: 1)
        
        let expectedInvertedDegenerateTransform = AffineTransform(a:  1,  b:  5,
                                                                  c:  1,  d:  5,
                                                                  tx: 12, ty: 43)

        // When
        let returnedTransform1 = transform1.inverted()
        let returnedTransform2 = expectedTransform2.inverted().inverted()
        let returnedInvertedDegenerateTransform = expectedInvertedDegenerateTransform.inverted()
        
        // Then
        XCTAssertEqual(expectedTransform1, returnedTransform1)
        XCTAssertEqual(expectedTransform2, returnedTransform2)
        XCTAssertEqual(expectedInvertedDegenerateTransform, returnedInvertedDegenerateTransform)
    }
    
    func testConcatenateWithRotation() {
        
        // Given
        let transform1 = AffineTransform(a:  1,  b:  5,
                                         c:  4,  d:  6,
                                         tx: 12, ty: 43)
        
        let expectedTransform1 = AffineTransform(a:  -2.61642289, b:  -7.08755684,
                                                 c:  -3.18658614, d:  -3.28123975,
                                                 tx: 12,          ty: 43)
        
        let transform2 = AffineTransform(a:  1,  b:  0,
                                         c:  3,  d:  2,
                                         tx: 12, ty: 43)
        
        let expectedTransform2 = AffineTransform(a:  -0.999999523, b:  0.000000301991605,
                                                 c:  -3.00000024,  d:  -2,
                                                 tx: 12,           ty: 43)

        // When
        let returnedTransform1 = transform1.rotated(byAngle: 35)
        let returnedTransform2 = transform2.rotated(byAngle: .pi)
        
        // Then
        XCTAssertEqual(expectedTransform1, returnedTransform1)
        XCTAssertEqual(expectedTransform2, returnedTransform2)
    }
    
    func testConcatenateWithScaling() {
        
        // Given
        let transform1 = AffineTransform(a:  1,  b:  5,
                                         c:  4,  d:  6,
                                         tx: 12, ty: 43)
        
        let expectedTransform1 = AffineTransform(a:  2.6, b:  13.0,
                                                 c:  1.6, d:  2.4,
                                                 tx: 12,  ty: 43)
        
        let transform2 = AffineTransform(a:  1,  b:  0,
                                         c:  3,  d:  2,
                                         tx: 12, ty: 43)
        
        let expectedTransform2 = AffineTransform(a:  -1, b:  0,
                                                 c:  3,  d:  2,
                                                 tx: 12, ty: 43)
        
        // When
        let returnedTransform1 = transform1.scaled(byX: 2.6, y: 0.4)
        let returnedTransform2 = transform2.scaled(byX: -1, y: 1)
        
        // Then
        XCTAssertEqual(expectedTransform1, returnedTransform1)
        XCTAssertEqual(expectedTransform2, returnedTransform2)
    }
    
    func testConcatenateWithTranslation() {
        
        // Given
        let transform1 = AffineTransform(a:  1,  b:  5,
                                         c:  4,  d:  6,
                                         tx: 12, ty: 43)
        
        let expectedTransform1 = AffineTransform(a:  1,  b:  5,
                                                 c:  4,  d:  6,
                                                 tx: 6,  ty: 69)
        
        let transform2 = AffineTransform(a:  1,  b:  0,
                                         c:  3,  d:  2,
                                         tx: 12, ty: 43)
        
        let expectedTransform2 = AffineTransform(a:  1,   b:  0,
                                                 c:  3,   d:  2,
                                                 tx: 114, ty: 111)
        
        // When
        let returnedTransform1 = transform1.translated(byX: 10, y: -4)
        let returnedTransform2 = transform2.translated(byX: 0, y: 34)
        
        // Then
        XCTAssertEqual(expectedTransform1, returnedTransform1)
        XCTAssertEqual(expectedTransform2, returnedTransform2)
    }
    
    func testApplyTransformToSize() {
        
        // Given
        let size = Size(width: 44, height: 12)
        let transform = AffineTransform(a:  1,  b:  5,
                                        c:  4,  d:  6,
                                        tx: 12, ty: 43)
        
        let expectedSize = Size(width: 92, height: 292)
        
        // When
        let returnedSize = size.applying(transform)
        
        // Then
        XCTAssertEqual(expectedSize, returnedSize)
    }
    
    func testApplyTransformToPoint() {
        
        // Given
        let point = Point(x: 44, y: 12)
        let transform = AffineTransform(a:  1,  b:  5,
                                        c:  4,  d:  6,
                                        tx: 12, ty: 43)
        
        let expectedPoint = Point(x: 104, y: 335)
        
        // When
        let returnedPoint = point.applying(transform)
        
        // Then
        XCTAssertEqual(expectedPoint, returnedPoint)
    }
}
