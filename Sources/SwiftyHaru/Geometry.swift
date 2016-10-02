//
//  Geometry.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 01.10.16.
//
//

import CLibHaru

public typealias Size = (width: Float, height: Float)
public typealias Point = (x: Float, y: Float)

internal func _Point(_ hpdfPoint: HPDF_Point) -> Point {
    return (x: hpdfPoint.x, y: hpdfPoint.y)
}

infix operator ×

/// Constructs a size from provided numeric values
///
/// - parameter width: The width.
/// - parameter height: The height.
///
/// - returns: The size representing provided width and height.
public func × (width: Float, height: Float) -> Size {
    return (width: width, height: height)
}
