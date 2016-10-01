//
//  Size.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 01.10.16.
//
//

public struct Size<T: Numeric> {
    public var width: T
    public var height: T
}

infix operator ×

/// Constructs a size from provided numeric values
///
/// - parameter width: The width.
/// - parameter height: The height.
///
/// - returns: The size representing provided width and height.
public func × <T: Numeric>(width: T, height: T) -> Size<T> {
    return Size(width: width, height: height)
}
