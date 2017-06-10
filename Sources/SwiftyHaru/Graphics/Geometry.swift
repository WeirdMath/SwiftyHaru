//
//  Geometry.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 01.10.16.
//
//

#if SWIFT_PACKAGE
import typealias CLibHaru.HPDF_Point
#endif

public struct Size {
    
    public var width: Float
    public var height: Float
    
    public init(width: Float, height: Float) {
        self.width = width
        self.height = height
    }
}

extension Size: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Size, rhs: Size) -> Bool {
        return lhs.width == rhs.width && lhs.height == rhs.height
    }
}

public struct Point {
    
    public static let zero = Point(x: 0, y: 0)
    
    public var x: Float
    public var y: Float
    
    public init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
    
    public static func +(lhs: Point, rhs: Vector) -> Point {
        
        return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    public static func -(lhs: Point, rhs: Vector) -> Point {
        
        return Point(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}

extension Point: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

internal extension Point {
    
    internal init(_ hpdfPoint: HPDF_Point) {
        x = hpdfPoint.x
        y = hpdfPoint.y
    }
}

public typealias Vector = Point

public struct Rectangle {
    
    public var origin: Point
    
    public var size: Size
    
    public var x: Float {
        return origin.x
    }
    
    public var y: Float {
        return origin.y
    }
    
    public var width: Float {
        return size.width
    }
    
    public var height: Float {
        return size.height
    }
    
    public var center: Point {
        return Point(x: (2 * x + width) / 2, y: (2 * y + height) / 2)
    }
    
    public var midX: Float {
        return center.x
    }
    
    public var midY: Float {
        return center.y
    }

    public var maxX: Float {
        return x + width
    }

    public var maxY: Float {
        return y + height
    }
    
    public init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
    
    public init(x: Float, y: Float, width: Float, height: Float) {
        self.init(origin: Point(x: x, y: y), size: Size(width: width, height: height))
    }
}

extension Rectangle: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Rectangle, rhs: Rectangle) -> Bool {
        return lhs.origin == rhs.origin && lhs.size == rhs.size
    }
}

infix operator ×

/// Constructs a size from provided numeric values
///
/// - parameter width: The width.
/// - parameter height: The height.
///
/// - returns: The size representing provided width and height.
internal func × (width: Float, height: Float) -> Size {
    return Size(width: width, height: height)
}
