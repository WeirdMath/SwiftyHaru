//
//  AffineTransform.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 25/06/2017.
//
//

import Foundation
#if SWIFT_PACKAGE
import struct CLibHaru.HPDF_TransMatrix
#endif

/// An affine transformation matrix is used to rotate, scale, translate, or skew the objects you draw
/// in a graphics context. The `AffineTransform` type provides functions for creating, concatenating,
/// and applying affine transformations.
///
/// Affine transforms are represented by a 3 by 3 matrix:
///
/// ```
/// / a  b  0 \
/// | c  d  0 |
/// \ tx ty 1 /
/// ```
///
/// Because the third column is always `(0,0,1)`, the `AffineTransform` structure contains values for only
/// the first two columns.
///
/// Conceptually, an affine transform multiplies a row vector representing each point `(x,y)` in your drawing
/// by this matrix, producing a vector that represents the corresponding point `(x’,y’)`:
/// ```
///                       / a  b  0 \
/// (x’ y’ 1) = (x y 1) × | c  d  0 |
///                       \ tx ty 1 /
/// ```
///
/// Given the 3 by 3 matrix, the following equations are used to transform a point `(x, y)` in one
/// coordinate system into a resultant point `(x’,y’)` in another coordinate system.
/// ```
/// x’ = a * x + c * y + tx
/// y’ = b * x + d * y + ty
/// ```
///
/// The matrix thereby “links” two coordinate systems — it specifies how points in one coordinate
/// system map to points in another.
///
/// Note that you do not typically need to create affine transforms directly.
/// If you want only to draw an object that is scaled or rotated, for example, it is not necessary
/// to construct an affine transform to do so. The most direct way to manipulate your drawing —
/// whether by movement, scaling, or rotation — is to call the functions `translateBy(x:y:)`, `scaleBy(x:y:)`,
/// or `rotate(by:)`, respectively.
public struct AffineTransform: Hashable {
    
    /// The entry at position [1,1] in the matrix.
    public var a: Float
    
    /// The entry at position [1,2] in the matrix.
    public var b: Float
    
    /// The entry at position [2,1] in the matrix.
    public var c: Float
    
    /// The entry at position [2,2] in the matrix.
    public var d: Float
    
    /// The entry at position [3,1] in the matrix.
    public var tx: Float
    
    /// The entry at position [3,2] in the matrix.
    public var ty: Float
    
    /// Creates a new affine transformation using the matrix with provided values.
    ///
    /// - Parameters:
    ///   - a:  The entry at position [1,1] in the matrix.
    ///   - b:  The entry at position [1,2] in the matrix.
    ///   - c:  The entry at position [2,1] in the matrix.
    ///   - d:  The entry at position [2,2] in the matrix.
    ///   - tx: The entry at position [3,1] in the matrix.
    ///   - ty: The entry at position [3,2] in the matrix.
    public init(a:  Float, b:  Float,
                c:  Float, d:  Float,
                tx: Float, ty: Float) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.tx = tx
        self.ty = ty
    }
    
    /// Creates an affine transformation matrix constructed from a rotation value you provide.
    ///
    /// This function creates a `AffineTransform` structure, which you can use (and reuse, if you want)
    /// to rotate a coordinate system. The matrix takes the following form:
    /// ```
    /// / cos(angle)  sin(angle)  0 \
    /// | -sin(angle) cos(angle)  0 |
    /// \ 0           0           1 /
    /// ```
    ///
    /// These are the resulting equations used to apply the rotation to a point `(x, y)`:
    /// ```
    /// x’ = x * cos(angle) - y * sin(angle)
    /// y’ = x * sin(angle) + y * sin(angle)
    /// ```
    /// - Parameter angle: The angle, in radians, by which this matrix rotates the coordinate system axes.
    @inlinable
    public init(rotationAngle angle: Float) {
        
        let cosine = cos(angle)
        let sine = sin(angle)
        
        self.init(a:  cosine, b:  sine,
                  c:  -sine,  d:  cosine,
                  tx: 0,      ty: 0)
    }
    
    /// Creates an affine transformation matrix constructed from scaling values you provide.
    ///
    /// This function creates a `AffineTransform` structure, which you can use (and reuse, if you want)
    /// to scale a coordinate system. The matrix takes the following form:
    /// ```
    /// / sx 0  0 \
    /// | 0  sy 0 |
    /// \ 0  0  1 /
    /// ```
    ///
    /// These are the resulting equations used to scale the coordinates of a point `(x,y)`:
    /// ```
    /// x’ = x * sx
    /// y’ = y * sy
    /// ```
    ///
    /// - Parameters:
    ///   - sx: The factor by which to scale the x-axis of the coordinate system.
    ///   - sy: The factor by which to scale the y-axis of the coordinate system.
    @inlinable
    public init(scaleX sx: Float, y sy: Float) {
        self.init(a:  sx, b:  0,
                  c:  0,  d:  sy,
                  tx: 0,  ty: 0)
    }
    
    /// Returns an affine transformation matrix constructed from translation values you provide.
    ///
    /// This function creates a `AffineTransform` structure, which you can use (and reuse, if you want)
    /// to move a coordinate system. The matrix takes the following form:
    /// ```
    /// / 1  0  0 \
    /// | 0  1  0 |
    /// \ tx ty 1 /
    /// ```
    ///
    /// These are the resulting equations used to apply the translation to a point `(x,y)`:
    /// ```
    /// x’ = x + tx
    /// y’ = y + ty
    /// ```
    ///
    /// - Parameters:
    ///   - tx: The value by which to move the x-axis of the coordinate system.
    ///   - ty: The value by which to move the y-axis of the coordinate system.
    @inlinable
    public init(translationX tx: Float, y ty: Float) {
        self.init(a:  1,  b:  0,
                  c:  0,  d:  1,
                  tx: tx, ty: ty)
    }
    
    /// Checks whether an affine transform is the identity transform.
    @inlinable
    public var isIdentity: Bool {
        return self == .identity
    }
    
    /// The identity transform:
    ///
    /// ```
    /// / 1 0 0 \
    /// | 0 1 0 |
    /// \ 0 0 1 /
    /// ```
    public static let identity = AffineTransform(a:  1, b:  0,
                                                 c:  0, d:  1,
                                                 tx: 0, ty: 0)
    
    /// Returns an affine transformation matrix constructed by combining two existing affine transforms.
    ///
    /// Concatenation combines two affine transformation matrices by multiplying them together.
    /// You might perform several concatenations in order to create a single affine transform that contains
    /// the cumulative effects of several transformations.
    ///
    /// Note that matrix operations are not commutative—the order in which you concatenate matrices is important.
    /// That is, the result of multiplying matrix `t1` by matrix `t2` does not necessarily
    /// equal the result of multiplying matrix `t2` by matrix `t1`.
    ///
    /// - Parameter other: The affine transform to concatenate to this affine transform.
    /// - Returns: A new affine transformation matrix. That is, `t’ = self * other`.
    @inlinable
    public func concatenating(_ other: AffineTransform) -> AffineTransform {
        return AffineTransform(a:  a * other.a + b * other.c,
                               b:  a * other.b + b * other.d,
                               c:  c * other.a + d * other.c,
                               d:  c * other.b + d * other.d,
                               tx: tx * other.a + ty * other.c + other.tx,
                               ty: tx * other.b + ty * other.d + other.ty)
    }
    
    /// Returns an affine transformation matrix constructed by inverting an existing affine transform.
    ///
    /// Inversion is generally used to provide reverse transformation of points within transformed objects.
    /// Given the coordinates `(x,y)`, which have been transformed by a given matrix to new coordinates `(x’,y’)`,
    /// transforming the coordinates `(x’,y’)` by the inverse matrix produces the original coordinates `(x,y)`.
    ///
    /// - Returns: A new affine transformation matrix.
    ///            If the affine transform cannot be inverted, it is returned unchanged.
    @inlinable
    public func inverted() -> AffineTransform {
        let det = determinant
        guard det != 0 else { return self }
        return AffineTransform(a:  d / det,
                               b:  -b / det,
                               c:  -c / det,
                               d:  a / det,
                               tx: (-d * tx + c * ty) / det,
                               ty: (b * tx - a * ty) / det)
    }
    
    /// Returns an affine transformation matrix constructed by rotating `self`.
    ///
    /// You use this function to create a new affine transformation matrix by adding a rotation value
    /// to an existing affine transform. The resulting structure represents a new affine transform,
    /// which you can use (and reuse, if you want) to rotate a coordinate system.
    ///
    /// - Parameter angle: The angle, in radians, by which to rotate the affine transform.
    /// - Returns: A new affine transformation matrix.
    @inlinable
    public func rotated(byAngle angle: Float) -> AffineTransform {
        return AffineTransform(rotationAngle: angle).concatenating(self)
    }
    
    /// Returns an affine transformation matrix constructed by scaling `self`.
    ///
    /// You use this function to create a new affine transformation matrix by adding scaling values to
    /// an existing affine transform. The resulting structure represents a new affine transform,
    /// which you can use (and reuse, if you want) to scale a coordinate system.
    ///
    /// - Parameters:
    ///   - x: The value by which to scale x values of the affine transform.
    ///   - y: The value by which to scale y values of the affine transform.
    /// - Returns: A new affine transformation matrix.
    @inlinable
    public func scaled(byX x: Float, y: Float) -> AffineTransform {
        return AffineTransform(scaleX: x, y: y).concatenating(self)
    }
    
    /// Returns an affine transformation matrix constructed by translating an existing affine transform.
    ///
    /// You use this function to create a new affine transform by adding translation values to
    /// an existing affine transform. The resulting structure represents a new affine transform,
    /// which you can use (and reuse, if you want) to move a coordinate system.
    ///
    /// - Parameters:
    ///   - tx: The value by which to move x values with the affine transform.
    ///   - ty: The value by which to move y values with the affine transform.
    /// - Returns: A new affine transformation matrix.
    @inlinable
    public func translated(byX tx: Float, y ty: Float) -> AffineTransform {
        return AffineTransform(translationX: tx, y: ty).concatenating(self)
    }
    
    /// Multiplies two matrices.
    ///
    /// This is analogous to calling `lhs.concatenating(rhs)`.
    ///
    /// Note that matrix operations are not commutative—the order in which you concatenate matrices is important.
    /// That is, the result of multiplying matrix `lhs` by matrix `rhs` does not necessarily
    /// equal the result of multiplying matrix `rhs` by matrix `lhs`.
    ///
    /// - Parameters:
    ///   - lhs: The left operand.
    ///   - rhs: The right operand.
    /// - Returns: A new affine transformation matrix.
    @inlinable
    public static func * (lhs: AffineTransform, rhs: AffineTransform) -> AffineTransform {
        return lhs.concatenating(rhs)
    }

    /// The determinant of this matrix, computed as `a * d - c * b`.
    @inlinable
    public var determinant: Float {
        return a * d - c * b
    }

    /// Whether `determinant` is zero.
    @inlinable
    public var isDegenerate: Bool {
        return determinant.isZero
    }
}

extension AffineTransform {
    
    internal init(_ t: HPDF_TransMatrix) {
        self.init(a: t.a, b: t.b, c: t.c, d: t.d, tx: t.x, ty: t.y)
    }
}

extension AffineTransform: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        
        let maxWidth = [a, b, c, d, tx, ty]
            .map(String.init(_:))
            .map { $0.count }
            .max()!
        
        func numberToAlignedString(_ number: Float) -> String {
            
            let stringRepresentation = String(number)
            
            let numberOfSpacesToAppend = maxWidth - stringRepresentation.count
            
            return stringRepresentation + String(repeating: " ", count: numberOfSpacesToAppend)
        }
        
        return """
        / \(numberToAlignedString(a)) \(numberToAlignedString(b)) 0 \\
        | \(numberToAlignedString(c)) \(numberToAlignedString(d)) 0 |
        \\ \(numberToAlignedString(tx)) \(numberToAlignedString(ty)) 1 /

        """
    }
}

extension AffineTransform: CustomStringConvertible {
    
    public var description: String { return debugDescription }
}
