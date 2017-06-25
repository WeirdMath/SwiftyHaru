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

/// A structure that contains width and height values.
public struct Size {
    
    /// A width value.
    public var width: Float
    
    /// A height value.
    public var height: Float
    
    /// Creates a size with dimensions specified as floating-point values.
    ///
    /// - Parameters:
    ///   - width: A width value.
    ///   - height: A height value.
    public init(width: Float, height: Float) {
        self.width = width
        self.height = height
    }
    
    /// Creates a size with dimensions specified as integer values.
    ///
    /// - Parameters:
    ///   - width: A width value.
    ///   - height: A height value.
    public init(width: Int, height: Int) {
        self.init(width: Float(width), height: Float(height))
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

/// A structure that contains a point in a two-dimensional coordinate system.
public struct Point {
    
    /// The point with location (0, 0).
    public static let zero = Point(x: 0, y: 0)
    
    /// The x-coordinate of the point.
    public var x: Float
    
    /// The y-coordinate of the point.
    public var y: Float
    
    /// Creates a point with coordinates specified as floating-point values.
    ///
    /// - Parameters:
    ///   - x: The x-coordinate of the point.
    ///   - y: The y-coordinate of the point.
    public init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
    
    /// Creates a point with coordinates specified as integer values.
    ///
    /// - Parameters:
    ///   - x: The x-coordinate of the point.
    ///   - y: The y-coordinate of the point.
    public init(x: Int, y: Int) {
        self.init(x: Float(x), y: Float(y))
    }
    
    /// Translates the `lhs` point by the specified `rhs` vector.
    ///
    /// - Parameters:
    ///   - lhs: The point to translate.
    ///   - rhs: The difference vector.
    /// - Returns: The point created by translation the `lhs` point by the `rhs` vector.
    public static func +(lhs: Point, rhs: Vector) -> Point {
        
        return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    /// Translates the `lhs` point by negation of the specified `rhs` vector.
    ///
    /// - Parameters:
    ///   - lhs: The point to translate.
    ///   - rhs: The difference vector.
    /// - Returns: The point created by translation the `lhs` point by negation of the `rhs` vector.
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

/// The two-dimentional vector is inherently a two-dimentional point.
public typealias Vector = Point

/// A structure that contains the location and dimensions of a rectangle.
public struct Rectangle {
    
    /// A point that specifies the coordinates of the rectangle’s origin.
    public var origin: Point
    
    /// A size that specifies the height and width of the rectangle.
    public var size: Size
    
    /// The x-coordinate of the `origin`.
    public var x: Float {
        return origin.x
    }
    
    /// The y-coordinate of the `origin`.
    public var y: Float {
        return origin.y
    }
    
    /// The width of a rectangle.
    public var width: Float {
        return size.width
    }
    
    /// The height of a rectangle.
    public var height: Float {
        return size.height
    }
    
    /// The center point of the rectangle.
    public var center: Point {
        return Point(x: (2 * x + width) / 2, y: (2 * y + height) / 2)
    }
    
    /// The x-coordinate that establishes the center of a rectangle.
    public var midX: Float {
        return center.x
    }
    
    /// The y-coordinate that establishes the center of the rectangle.
    public var midY: Float {
        return center.y
    }

    /// The largest value of the x-coordinate for the rectangle.
    public var maxX: Float {
        return x + width
    }

    /// The largest value of the y-coordinate for the rectangle.
    public var maxY: Float {
        return y + height
    }
    
    /// Creates a rectangle with the specified origin and size.
    ///
    /// - Parameters:
    ///   - origin: A point that specifies the coordinates of the rectangle’s origin.
    ///   - size:   A size that specifies the height and width of the rectangle.
    public init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
    
    /// Creates a rectangle with coordinates and dimensions specified as floating-point values.
    ///
    /// - Parameters:
    ///   - x: The x-coordinate of the origin.
    ///   - y: The y-coordinate of the origin.
    ///   - width: The width of a rectangle.
    ///   - height: The height of a rectangle.
    public init(x: Float, y: Float, width: Float, height: Float) {
        self.init(origin: Point(x: x, y: y), size: Size(width: width, height: height))
    }
    
    /// Creates a rectangle with coordinates and dimensions specified as integer values.
    ///
    /// - Parameters:
    ///   - x: The x-coordinate of the origin.
    ///   - y: The y-coordinate of the origin.
    ///   - width: The width of a rectangle.
    ///   - height: The height of a rectangle.
    public init(x: Int, y: Int, width: Int, height: Int) {
        self.init(x: Float(x), y: Float(y), width: Float(width), height: Float(height))
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
