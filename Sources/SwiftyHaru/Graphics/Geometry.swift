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
public struct Size: Hashable {
    
    /// A width value.
    public var width: Float
    
    /// A height value.
    public var height: Float
    
    /// Creates a size with dimensions specified as floating-point values.
    ///
    /// - Parameters:
    ///   - width: A width value.
    ///   - height: A height value.
    @inlinable
    public init(width: Float, height: Float) {
        self.width = width
        self.height = height
    }
    
    /// Creates a size with dimensions specified as integer values.
    ///
    /// - Parameters:
    ///   - width: A width value.
    ///   - height: A height value.
    @inlinable
    public init(width: Int, height: Int) {
        self.init(width: Float(width), height: Float(height))
    }
    
    /// Returns the height and width resulting from a transformation of an existing height and width.
    ///
    /// - Parameter transform: The affine transform to apply.
    /// - Returns: A new size resulting from applying the specified affine transform to the existing size.
    @inlinable
    public func applying(_ transform: AffineTransform) -> Size {
        return Size(width: transform.a * width + transform.c * height,
                    height: transform.b * width + transform.d * height)
    }
}

extension Size: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "(\(width), \(height))"
    }
}

/// A structure that contains a point in a two-dimensional coordinate system.
public struct Point: Hashable {
    
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
    @inlinable
    public init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
    
    /// Creates a point with coordinates specified as integer values.
    ///
    /// - Parameters:
    ///   - x: The x-coordinate of the point.
    ///   - y: The y-coordinate of the point.
    @inlinable
    public init(x: Int, y: Int) {
        self.init(x: Float(x), y: Float(y))
    }
    
    /// Translates the `lhs` point by the specified `rhs` vector.
    ///
    /// - Parameters:
    ///   - lhs: The point to translate.
    ///   - rhs: The difference vector.
    /// - Returns: The point created by translation the `lhs` point by the `rhs` vector.
    @inlinable
    public static func +(lhs: Point, rhs: Vector) -> Point {
        return Point(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
    }
    
    /// Translates the `lhs` point by negation of the specified `rhs` vector.
    ///
    /// - Parameters:
    ///   - lhs: The point to translate.
    ///   - rhs: The difference vector.
    /// - Returns: The point created by translation the `lhs` point by negation of the `rhs` vector.
    @inlinable
    public static func -(lhs: Point, rhs: Vector) -> Point {
        return Point(x: lhs.x - rhs.dx, y: lhs.y - rhs.dy)
    }

    /// Returns the vector that needs to be added to `rhs` to get `lhs`.
    ///
    /// - Parameters:
    ///   - lhs: The first point.
    ///   - rhs: The second point.
    /// - Returns: The vector that needs to be added to `rhs` to get `lhs`.
    @inlinable
    public static func -(lhs: Point, rhs: Point) -> Vector {
        return Vector(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
    }
    
    /// Returns the point resulting from an affine transformation of an existing point.
    ///
    /// - Parameter transform: The affine transform to apply.
    /// - Returns: A new point resulting from applying the specified affine transform to the existing point.
    @inlinable
    public func applying(_ transform: AffineTransform) -> Point {
        return Point(x: transform.a * x + transform.c * y + transform.tx,
                     y: transform.b * x + transform.d * y + transform.ty)
    }
}

extension Point: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "(\(x), \(y))"
    }
}

extension Point {
    internal init(_ hpdfPoint: HPDF_Point) {
        x = hpdfPoint.x
        y = hpdfPoint.y
    }
}

public struct Vector: Hashable {

    /// The vector whose components are both zero.
    public static let zero = Vector(dx: 0, dy: 0)

    /// The x component of the vector.
    public var dx: Float

    /// The y component of the vector.
    public var dy: Float

    /// Creates a vector with components specified as floating-point values.
    ///
    /// - Parameters:
    ///   - dx: The x component of the vector.
    ///   - dy: The y component of the vector.
    @inlinable
    public init(dx: Float, dy: Float) {
        self.dx = dx
        self.dy = dy
    }

    /// Creates a vector with components specified as integer values.
    ///
    /// - Parameters:
    ///   - x: The x-coordinate of the point.
    ///   - y: The y-coordinate of the point.
    @inlinable
    public init(dx: Int, dy: Int) {
        self.init(dx: Float(dx), dy: Float(dy))
    }

    /// Returns the given vector unchanged.
    ///
    /// You can use the unary plus operator (+) to provide symmetry in your code.
    ///
    /// - Parameter x: A vector.
    /// - Returns: The given argument without any changes.
    @inlinable
    public prefix static func +(x: Vector) -> Vector {
        return x
    }

    /// Returns the inverse of the specified vector.
    ///
    /// - Parameter x: A vector.
    /// - Returns: The inverse of this vector.
    @inlinable
    public prefix static func -(x: Vector) -> Vector {
        return Vector(dx: -x.dx, dy: -x.dy)
    }

    /// Adds two vectors and produces their sum vector.
    ///
    /// - Parameters:
    ///   - lhs: The first vector to add.
    ///   - rhs: The second vector to add.
    /// - Returns: The sum vector.
    @inlinable
    public static func +(lhs: Vector, rhs: Vector) -> Vector {
        return Vector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }

    /// Subtracts one value from another and produces their difference vector.
    ///
    /// - Parameters:
    ///   - lhs: A vector.
    ///   - rhs: The vector to subtract from `lhs`.
    /// - Returns: The difference vector.
    @inlinable
    public static func -(lhs: Vector, rhs: Vector) -> Vector {
        return Vector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }

    /// Multiplies a vector by a floating-point scalar value.
    ///
    /// - Parameters:
    ///   - lhs: A vector.
    ///   - rhs: A floating-point scalar value.
    /// - Returns: The scaled vector.
    @inlinable
    public static func *(lhs: Vector, rhs: Float) -> Vector {
        return Vector(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
    }

    /// Multiplies a vector by an integer scalar value.
    ///
    /// - Parameters:
    ///   - lhs: A vector.
    ///   - rhs: An integer scalar value.
    /// - Returns: The scaled vector.
    @inlinable
    public static func *(lhs: Vector, rhs: Int) -> Vector {
        return Vector(dx: lhs.dx * Float(rhs), dy: lhs.dy * Float(rhs))
    }

    /// Multiplies a vector by a floating-point scalar value.
    ///
    /// - Parameters:
    ///   - lhs: A floating-point scalar value.
    ///   - rhs: A vector.
    /// - Returns: The scaled vector.
    @inlinable
    public static func *(lhs: Float, rhs: Vector) -> Vector {
        return Vector(dx: rhs.dx * lhs, dy: rhs.dy * lhs)
    }

    /// Multiplies a vector by an integer scalar value.
    ///
    /// - Parameters:
    ///   - lhs: An integer scalar value.
    ///   - rhs: A vector.
    /// - Returns: The scaled vector.
    @inlinable
    public static func *(lhs: Int, rhs: Vector) -> Vector {
        return Vector(dx: rhs.dx * Float(lhs), dy: rhs.dy * Float(lhs))
    }
}

extension Vector: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "(\(dx), \(dy))"
    }
}

/// A structure that contains the location and dimensions of a rectangle.
public struct Rectangle: Hashable {
    
    /// A point that specifies the coordinates of the rectangle’s origin.
    public var origin: Point
    
    /// A size that specifies the height and width of the rectangle.
    public var size: Size
    
    /// The x-coordinate of the `origin`.
    @inlinable
    public var x: Float {
        return origin.x
    }
    
    /// The y-coordinate of the `origin`.
    @inlinable
    public var y: Float {
        return origin.y
    }
    
    /// The width of a rectangle.
    @inlinable
    public var width: Float {
        return size.width
    }
    
    /// The height of a rectangle.
    @inlinable
    public var height: Float {
        return size.height
    }
    
    /// The center point of the rectangle.
    @inlinable
    public var center: Point {
        return Point(x: (2 * x + width) / 2, y: (2 * y + height) / 2)
    }
    
    /// The x-coordinate that establishes the center of a rectangle.
    @inlinable
    public var midX: Float {
        return center.x
    }
    
    /// The y-coordinate that establishes the center of the rectangle.
    @inlinable
    public var midY: Float {
        return center.y
    }

    /// The largest value of the x-coordinate for the rectangle.
    @inlinable
    public var maxX: Float {
        return x + width
    }

    /// The largest value of the y-coordinate for the rectangle.
    @inlinable
    public var maxY: Float {
        return y + height
    }
    
    /// Creates a rectangle with the specified origin and size.
    ///
    /// - Parameters:
    ///   - origin: A point that specifies the coordinates of the rectangle’s origin.
    ///   - size:   A size that specifies the height and width of the rectangle.
    @inlinable
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
    @inlinable
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
    @inlinable
    public init(x: Int, y: Int, width: Int, height: Int) {
        self.init(x: Float(x), y: Float(y), width: Float(width), height: Float(height))
    }
}

extension Rectangle: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "(\(x), \(y), \(width), \(height))"
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
