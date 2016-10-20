//
//  Path.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 08.10.16.
//
//

/// A type for graphics paths: mathematical descriptions of shapes or lines to be drawn in a `DrawingContext`.
public struct Path {
    
    /// Creates an empty path.
    public init() {}
    
    internal enum _PathConstructionOperation {
        case moveTo(Point)
        case lineTo(Point)
        case closePath
        case arc(center: Point, radius: Float, beginningAngle: Float, endAngle: Float)
        case circle(center: Point, radius: Float)
        case rectangle(Rectangle)
        case curve(controlPoint1: Point, controlPoint2: Point, endPoint: Point)
        case curve2(controlPoint2: Point, endPoint: Point)
        case curve3(controlPoint1: Point, endPoint: Point)
        case ellipse(center: Point, xRadius: Float, yRadius: Float)
    }
    
    internal var _pathConstructionSequence: [_PathConstructionOperation] = [.moveTo(.zero)]
    
    private var _currentPosition = Point.zero
    
    /// The current position for path construction. Initial value is `Point.zero`.
    public var currentPosition: Point {
        return _currentPosition
    }
    
    /// Starts a new subpath and moves the current point for drawing path,
    /// sets the start point for the path to the `point`.
    ///
    /// - parameter point: The start point for drawing path.
    public mutating func move(to point: Point) {
        _currentPosition = point
        _pathConstructionSequence.append(.moveTo(point))
    }
    
    /// Creates a new path by starting a new subpath in the old one and moves the current point for drawing path,
    /// sets the start point for the new path to the `point`.
    ///
    /// - parameter point: The start point for drawing path.
    ///
    /// - returns: The new path.
    public func moving(to point: Point) -> Path {
        var path = self
        path.move(to: point)
        return path
    }
    
    /// Starts a new subpath and moves the current point for drawing path,
    /// sets the start point for the path to the point with the specified coordinates.
    ///
    /// - parameter x: The x coordinate of the start point for drawing path.
    /// - parameter y: The y coordinate of the start point for drawing path.
    public mutating func move(toX x: Float, y: Float) {
        move(to: Point(x: x, y: y))
    }
    
    /// Creates a new path by starting a new subpath in the old one and moves the current point for drawing path,
    /// sets the start point for the new path to the point with the specified coordinates.
    ///
    /// - parameter x: The x coordinate of the start point for drawing path.
    /// - parameter y: The y coordinate of the start point for drawing path.
    ///
    /// - returns: The new path.
    public func moving(toX x: Float, y: Float) -> Path {
        var path = self
        path.move(toX: x, y: y)
        return path
    }
    
    /// Appends a line from the current point to the specified point. If this method has been called before
    /// setting the current position by calling `move(to:)`, then `Point.zero` is used as one.
    ///
    /// - parameter point: The end point of the path.
    public mutating func appendLine(to point: Point) {
        _currentPosition = point
        _pathConstructionSequence.append(.lineTo(point))
    }
    
    /// Creates a new path by appending a line from the current point of the old path to the specified point.
    /// If this method has been called before
    /// setting the current position by calling `move(to:)`, then `Point.zero` is used as one.
    ///
    /// - parameter point: The end point of the new path.
    ///
    /// - returns: The new path.
    public func appendingLine(to point: Point) -> Path {
        var path = self
        path.appendLine(to: point)
        return path
    }
    
    /// Appends a line from the current point to the point with specified coordinates.
    /// If this method has been called before
    /// setting the current position by calling `move(to:)`, then `Point.zero` is used as one.
    ///
    /// - parameter x: The x coordinate of end point of the path.
    /// - parameter y: The y coordinate of end point of the path.
    public mutating func appendLine(toX x: Float, y: Float) {
        appendLine(to: Point(x: x, y: y))
    }
    
    /// Creates a new path by appending a line from the current point of the old path
    /// to the point with specified coordinates. If this method has been called before
    /// setting the current position by calling `move(to:)`, then `Point.zero` is used as one.
    ///
    /// - parameter x: The x coordinate of end point of the path.
    /// - parameter y: The y coordinate of end point of the path.
    ///
    /// - returns: The new path.
    public func appendingLine(toX x: Float, y: Float) -> Path {
        var path = self
        path.appendLine(toX: x, y: y)
        return path
    }
    
    /// Appends a straight line from the current point to the start point of subpath.
    /// The current point is moved to the start point of subpath.
    public mutating func closeSubpath() {
        
        let lastMoveToOperation = _pathConstructionSequence.reversed().first(where: { operation -> Bool in
            if case .moveTo = operation { return true }
            return false
        })
        
        if let lastMoveToOperation = lastMoveToOperation, case .moveTo(let point) = lastMoveToOperation {
            _currentPosition = point
            _pathConstructionSequence.append(.closePath)
        }
    }
    
    /// Creates a new path by appending a straight line from the current point of the old path
    /// to the start point of the subpath.
    /// The current point is moved to the start point of the subpath.
    ///
    /// - returns: The new path.
    public func closingSubpath() -> Path {
        var path = self
        path.closeSubpath()
        return path
    }
    
    /// Appends a circle arc to the current path. Angles are given in degrees, with 0 degrees being vertical,
    /// upward, and in clockwise direction.
    ///
    /// - parameter center:         The center point of the arc.
    /// - parameter radius:         The radius of the arc.
    /// - parameter beginningAngle: The angle of the begining of the arc.
    /// - parameter endAngle:       The angle of the end of the arc. It must be greater than `beginningAngle`.
    public mutating func appendArc(center: Point, radius: Float, beginningAngle: Float, endAngle: Float) {
        
        // TODO: Allow `beginningAngle` to be greater than `endAngle` by changing the direction.
        
        guard endAngle > beginningAngle else { return }
        
        _pathConstructionSequence.append(.arc(center: center,
                                              radius: radius,
                                              beginningAngle: beginningAngle,
                                              endAngle: endAngle))
    }
    
    /// Creates a new path by appending a circle arc to the old path.
    /// Angles are given in degrees, with 0 degrees being vertical,
    /// upward, and in clockwise direction.
    ///
    /// - parameter center:         The center point of the arc.
    /// - parameter radius:         The radius of the arc.
    /// - parameter beginningAngle: The angle of the begining of the arc.
    /// - parameter endAngle:       The angle of the end of the arc. It must be greater than `beginningAngle`.
    ///
    /// - returns: The new path.
    public func appendingArc(center: Point, radius: Float, beginningAngle: Float, endAngle: Float) -> Path {
        var path = self
        path.appendArc(center: center, radius: radius, beginningAngle: beginningAngle, endAngle: endAngle)
        return path
    }
    
    /// Appends a circle arc to the current path. Angles are given in degrees, with 0 degrees being vertical,
    /// upward, and in clockwise direction.
    ///
    /// - parameter x:              The x coordinate of the center point of the arc.
    /// - parameter y:              The y coordinate of the center point of the arc.
    /// - parameter radius:         The radius of the arc.
    /// - parameter beginningAngle: The angle of the begining of the arc.
    /// - parameter endAngle:       The angle of the end of the arc. It must be greater than `beginningAngle`.
    public mutating func appendArc(x: Float, y: Float, radius: Float, beginningAngle: Float, endAngle: Float) {
        appendArc(center: Point(x: x, y: y), radius: radius, beginningAngle: beginningAngle, endAngle: endAngle)
    }
    
    /// Creates a new path by appending a circle arc to the old path.
    /// Angles are given in degrees, with 0 degrees being vertical,
    /// upward, and in clockwise direction.
    ///
    /// - parameter x:              The x coordinate of the center point of the arc.
    /// - parameter y:              The y coordinate of the center point of the arc.
    /// - parameter radius:         The radius of the arc.
    /// - parameter beginningAngle: The angle of the begining of the arc.
    /// - parameter endAngle:       The angle of the end of the arc. It must be greater than `beginningAngle`.
    ///
    /// - returns: The new path.
    public func appendingArc(x: Float, y: Float, radius: Float, beginningAngle: Float, endAngle: Float) -> Path {
        var path = self
        path.appendArc(x: x, y: y, radius: radius, beginningAngle: beginningAngle, endAngle: endAngle)
        return path
    }
    
    /// Appends a circle to the current path, then sets the current point to the leftmost point of the circle,
    /// i. e. `Point(x: center.x - radius, y: center.y)`.
    ///
    /// - parameter center: The center point of the circle.
    /// - parameter radius: The radius of the circle.
    public mutating func appendCircle(center: Point, radius: Float) {
        _currentPosition = Point(x: center.x - radius, y: center.y)
        _pathConstructionSequence.append(.circle(center: center, radius: radius))
    }
    
    /// Creates a new path by appending a circle to the old path, then sets the current point
    /// to the leftmost point of the circle,
    /// i. e. `Point(x: center.x - radius, y: center.y)`.
    ///
    /// - parameter center: The center point of the circle.
    /// - parameter radius: The radius of the circle.
    ///
    /// - returns: The new path.
    public func appendingCircle(center: Point, radius: Float) -> Path {
        var path = self
        path.appendCircle(center: center, radius: radius)
        return path
    }
    
    /// Appends a circle to the current path, then sets the current point to the leftmost point of the circle,
    /// i. e. `Point(x: x - radius, y: y)`.
    ///
    /// - parameter x:      The x coordinate of the center point of the circle.
    /// - parameter y:      The y coordinate of the center point of the circle.
    /// - parameter radius: The radius of the circle.
    public mutating func appendCircle(x: Float, y: Float, radius: Float) {
        appendCircle(center: Point(x: x, y: y), radius: radius)
    }
    
    /// Creates a new path by appending a circle to the old path, then sets the current point
    /// to the leftmost point of the circle,
    /// i. e. `Point(x: x - radius, y: y)`.
    ///
    /// - parameter x:      The x coordinate of the center point of the circle.
    /// - parameter y:      The y coordinate of the center point of the circle.
    /// - parameter radius: The radius of the circle.
    ///
    /// - returns: The new path.
    public func appendingCircle(x: Float, y: Float, radius: Float) -> Path {
        var path = self
        path.appendCircle(x: x, y: y, radius: radius)
        return path
    }
    
    /// Appends a rectangle to the current path, then sets the current point to the lower-left
    /// point of the rectangle.
    ///
    /// - parameter rect: The rectangle to append.
    public mutating func appendRectangle(_ rect: Rectangle) {
        _currentPosition = rect.origin
        _pathConstructionSequence.append(.rectangle(rect))
    }
    
    /// Creates a new path by appending a rectangle to the old path, then sets the current point to the lower-left
    /// point of the rectangle.
    ///
    /// - parameter rect: The rectangle to append.
    ///
    /// - returns: The new path.
    public func appendingRectangle(_ rect: Rectangle) -> Path {
        var path = self
        path.appendRectangle(rect)
        return path
    }
    
    /// Appends a rectangle to the current path, then sets the current point to the lower-left
    /// point of the rectangle.
    ///
    /// - parameter origin: The lower-left point of the rectangle.
    /// - parameter size:   The size of the rectangle.
    public mutating func appendRectangle(origin: Point, size: Size) {
        appendRectangle(Rectangle(origin: origin, size: size))
    }
    
    /// Creates a new path by appending a rectangle to the old path, then sets the current point to the lower-left
    /// point of the rectangle.
    ///
    /// - parameter origin: The lower-left point of the rectangle.
    /// - parameter size:   The size of the rectangle.
    ///
    /// - returns: The new path.
    public func appendingRectangle(origin: Point, size: Size) -> Path {
        var path = self
        path.appendRectangle(origin: origin, size: size)
        return path
    }
    
    /// Appends a rectangle to the current path, then sets the current point to the lower-left
    /// point of the rectangle.
    ///
    /// - parameter x:      The x coordinate of the lower-left point of the rectangle.
    /// - parameter y:      The y coordinate of the lower-left point of the rectangle.
    /// - parameter width:  The width of the rectangle.
    /// - parameter height: The height of the rectangle.
    public mutating func appendRectangle(x: Float, y: Float, width: Float, height: Float) {
        appendRectangle(origin: Point(x: x, y:y), size: Size(width: width, height: height))
    }
    
    /// Creates a new path by appending a rectangle to the old path, then sets the current point to the lower-left
    /// point of the rectangle.
    ///
    /// - parameter x:      The x coordinate of the lower-left point of the rectangle.
    /// - parameter y:      The y coordinate of the lower-left point of the rectangle.
    /// - parameter width:  The width of the rectangle.
    /// - parameter height: The height of the rectangle.
    ///
    /// - returns: The new path.
    public func appendingRectangle(x: Float, y: Float, width: Float, height: Float) -> Path {
        var path = self
        path.appendRectangle(x: x, y: y, width: width, height: height)
        return path
    }
    
    /// Appends a Bézier curve to the current path using the control points `controlPoint1`,
    /// `controlPoint2` and `endPoint`, then sets the current point to `endPoint`.
    ///
    /// ![figure](http://libharu.org/figures/figure20.png "figure")
    ///
    /// - parameter controlPoint1: The first control point of the curve.
    /// - parameter controlPoint2: The second control point of the curve.
    /// - parameter endPoint: The end point of the curve.
    public mutating func appendCurve(controlPoint1: Point, controlPoint2: Point, endPoint: Point) {
        _currentPosition = endPoint
        _pathConstructionSequence.append(.curve(controlPoint1: controlPoint1,
                                                controlPoint2: controlPoint2,
                                                endPoint: endPoint))
    }
    
    /// Creates a new path by appending a Bézier curve to the old path using the control points `controlPoint1`,
    ///`controlPoint2` and `endPoint`, then sets the current point to `endPoint`.
    ///
    /// ![figure](http://libharu.org/figures/figure20.png "figure")
    ///
    /// - parameter controlPoint1: The first control point of the curve.
    /// - parameter controlPoint2: The second control point of the curve.
    /// - parameter endPoint:      The end point of the curve.
    ///
    /// - returns: The new path.
    public func appendingCurve(controlPoint1: Point, controlPoint2: Point, endPoint: Point) -> Path {
        var path = self
        path.appendCurve(controlPoint1: controlPoint1, controlPoint2: controlPoint2, endPoint: endPoint)
        return path
    }
    
    /// Appends a Bézier curve to the current path using two spesified points.
    /// The point `controlPoint1` and the point `endPoint` are used as the control points for
    /// a Bézier curve; the current point is moved to the `endPoint.`
    ///
    /// ![figure](http://libharu.org/figures/figure22.png "figure")
    ///
    /// - parameter controlPoint1: The first control point of the curve.
    /// - parameter endPoint:      The end point of the curve.
    public mutating func appendCurve(controlPoint1: Point, endPoint: Point) {
        _currentPosition = endPoint
        _pathConstructionSequence.append(.curve3(controlPoint1: controlPoint1, endPoint: endPoint))
    }
    
    /// Creates a new path by appending a Bézier curve to the old path using two spesified points.
    /// The point `controlPoint1` and the point `endPoint` are used as the control points for
    /// a Bézier curve; the current point is moved to the `endPoint.`
    ///
    /// ![figure](http://libharu.org/figures/figure22.png "figure")
    ///
    /// - parameter controlPoint1: The first control point of the curve.
    /// - parameter endPoint:      The end point of the curve.
    ///
    /// - returns: The new path.
    public func appendingCurve(controlPoint1: Point, endPoint: Point) -> Path {
        var path = self
        path.appendCurve(controlPoint1: controlPoint1, endPoint: endPoint)
        return path
    }
    
    /// Appends a Bézier curve to the current path using the current point, `controlPoint2` and
    /// `endPoint` as control points. Then, the current point is set to `endPoint`.
    ///
    /// ![figure](http://libharu.org/figures/figure21.png "figure")
    ///
    /// - parameter controlPoint2: The second control point of the curve.
    /// - parameter endPoint:      The end point of the curve.
    public mutating func appendCurve(controlPoint2: Point, endPoint: Point) {
        _currentPosition = endPoint
        _pathConstructionSequence.append(.curve2(controlPoint2: controlPoint2, endPoint: endPoint))
    }
    
    /// Creates a new path by appending a Bézier curve to the old path using the current point, `controlPoint2` and
    /// `endPoint` as control points. Then, the current point is set to `endPoint`.
    ///
    /// ![figure](http://libharu.org/figures/figure21.png "figure")
    ///
    /// - parameter controlPoint2: The second control point of the curve.
    /// - parameter endPoint:      The end point of the curve.
    ///
    /// - returns: The new path.
    public func appendingCurve(controlPoint2: Point, endPoint: Point) -> Path {
        var path = self
        path.appendCurve(controlPoint2: controlPoint2, endPoint: endPoint)
        return path
    }
    
    /// Appends an ellipse to the current path, then sets the current point to the leftmost point of the ellipse,
    /// i. e. `Point(x: center.x - horizontalRadius, y: center.y)`.
    ///
    /// - parameter center:           The center point of the ellipse.
    /// - parameter horizontalRadius: The horizontal radius of the ellipse.
    /// - parameter verticalRadius:   The vertical radius of the ellipse.
    public mutating func appendEllipse(center: Point, horizontalRadius: Float, verticalRadius: Float) {
        _currentPosition = Point(x: center.x - horizontalRadius, y: center.y)
        _pathConstructionSequence.append(.ellipse(center: center,
                                                  xRadius: horizontalRadius,
                                                  yRadius: verticalRadius))
    }
    
    /// Creates a new path by appending an ellipse to the old path, then sets the current point
    /// to the leftmost point of the ellipse,
    /// i. e. `Point(x: center.x - horizontalRadius, y: center.y)`.
    ///
    /// - parameter center:           The center point of the ellipse.
    /// - parameter horizontalRadius: The horizontal radius of the ellipse.
    /// - parameter verticalRadius:   The vertical radius of the ellipse.
    ///
    /// - returns: The new path.
    public func appendingEllipse(center: Point, horizontalRadius: Float, verticalRadius: Float) -> Path {
        var path = self
        path.appendEllipse(center: center, horizontalRadius: horizontalRadius, verticalRadius: verticalRadius)
        return path
    }
    
    /// Appends an ellipse to the current path, then sets the current point to the leftmost point of the ellipse,
    /// i. e. `Point(x: x - horizontalRadius, y: y)`.
    ///
    /// - parameter x:                The x coordinate of the center point of the ellipse.
    /// - parameter y:                The y coordinate of the center point of the ellipse.
    /// - parameter horizontalRadius: The horizontal radius of the ellipse.
    /// - parameter verticalRadius:   The vertical radius of the ellipse.
    public mutating func appendEllipse(x: Float, y: Float, horizontalRadius: Float, verticalRadius: Float) {
        appendEllipse(center: Point(x: x, y: y), horizontalRadius: horizontalRadius, verticalRadius: verticalRadius)
    }
    
    /// Creates a new path by appending an ellipse to the old path, then sets the current point
    /// to the leftmost point of the ellipse,
    /// i. e. `Point(x: x - horizontalRadius, y: y)`.
    ///
    /// - parameter x:                The x coordinate of the center point of the ellipse.
    /// - parameter y:                The y coordinate of the center point of the ellipse.
    /// - parameter horizontalRadius: The horizontal radius of the ellipse.
    /// - parameter verticalRadius:   The vertical radius of the ellipse.
    ///
    /// - returns: The new path.
    public func appendingEllipse(x: Float, y: Float, horizontalRadius: Float, verticalRadius: Float) -> Path {
        var path = self
        path.appendEllipse(x: x, y: y, horizontalRadius: horizontalRadius, verticalRadius: verticalRadius)
        return path
    }
    
    /// Appends an ellipse to the current path, then sets the current point to the leftmost point of the ellipse,
    /// i. e. `Point(x: rectangle.midX - rectangle.width / 2, y: rectangle.y + rectangle.height / 2)`.
    ///
    /// - parameter rectangle: The rectangle the ellipse should be inscribed in.
    public mutating func appendEllipse(inscribedIn rectangle: Rectangle) {
        appendEllipse(center: rectangle.center,
                horizontalRadius: rectangle.width / 2,
                verticalRadius: rectangle.height / 2)
    }

    /// Creates a new path by appending an ellipse to the old path, then sets the current point
    /// to the leftmost point of the ellipse,
    /// i. e. `Point(x: rectangle.midX - rectangle.width / 2, y: rectangle.y + rectangle.height / 2)`.
    ///
    /// - parameter rectangle: The rectangle the ellipse should be inscribed in.
    ///
    /// - returns: The new path.
    public func appendingEllipse(inscribedIn rectangle: Rectangle) -> Path {
        var path = self
        path.appendEllipse(inscribedIn: rectangle)
        return path
    }
}

extension Path._PathConstructionOperation: Equatable {
    
    internal static func ==(lhs: Path._PathConstructionOperation, rhs: Path._PathConstructionOperation) -> Bool {
        
        switch (lhs, rhs) {
        case (.moveTo(let point1), .moveTo(let point2)):
            return point1 == point2
        case (.lineTo(let point1), .lineTo(let point2)):
            return point1 == point2
        case (.closePath, .closePath):
            return true
        case (.arc(let center1, let radius1, let beginningAngle1, let endAngle1),
              .arc(let center2, let radius2, let beginningAngle2, let endAngle2)):
            return center1 == center2 &&
                radius1 == radius2 &&
                beginningAngle1 == beginningAngle2 &&
                endAngle1 == endAngle2
        case (.circle(let center1, let radius1), .circle(let center2, let radius2)):
            return center1 == center2 && radius1 == radius2
        case (.rectangle(let rect1), .rectangle(let rect2)):
            return rect1 == rect2
        case (.curve(let controlPoint11, let controlPoint21, let endPoint1),
              .curve(let controlPoint12, let controlPoint22, let endPoint2)):
            return controlPoint11 == controlPoint12 && controlPoint21 == controlPoint22 && endPoint1 == endPoint2
        case (.curve2(let controlPoint21, let endPoint1), .curve2(let controlPoint22, let endPoint2)):
            return controlPoint21 == controlPoint22 && endPoint1 == endPoint2
        case (.curve3(let controlPoint11, let endPoint1), curve3(let controlPoint12, let endPoint2)):
            return controlPoint11 == controlPoint12 && endPoint1 == endPoint2
        case (.ellipse(let center1, let xRadius1, let yRadius1), ellipse(let center2, let xRadius2, let yRadius2)):
            return center1 == center2 && xRadius1 == xRadius2 && yRadius1 == yRadius2
        default:
            return false
        }
    }
}

extension Path: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Path, rhs: Path) -> Bool {
        return lhs._pathConstructionSequence == rhs._pathConstructionSequence
    }

}
