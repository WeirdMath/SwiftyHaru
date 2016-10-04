//
//  PDFPathContext.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 02.10.16.
//
//

import CLibHaru

public final class PDFPathContext {
    
    private var _page: HPDF_Page
    
    internal init(for page: HPDF_Page) {
        _page = page
    }
    
    internal func _cleanup() {
        
        // Reset to the default state
        
        lineWidth = 1
        strokeColor = .black
        fillColor = .black
        
        move(to: .zero)
    }
    
    /// The current line width for path painting of the page. Default value is 1.
    public var lineWidth: Float {
        get {
            return HPDF_Page_GetLineWidth(_page)
        }
        set {
            HPDF_Page_SetLineWidth(_page, newValue)
        }
    }
    
    private var _currentPosition = Point.zero
    
    /// The current position for path painting. Default value is `Point.zero`.
    public var currentPosition: Point {
        return _currentPosition
    }
    
    /// The current value of the page's stroking color space.
    public var strokingColorSpace: PDFColorSpace {
        return PDFColorSpace(haruEnum: HPDF_Page_GetStrokingColorSpace(_page))
    }
    
    /// The current value of the page's filling color space.
    public var fillingColorSpace: PDFColorSpace {
        return PDFColorSpace(haruEnum: HPDF_Page_GetFillingColorSpace(_page))
    }
    
    /// The current value of the page's stroking color. Default is RGB black.
    public var strokeColor: Color {
        get {
            switch strokingColorSpace {
            case .deviceRGB:
                return Color(HPDF_Page_GetRGBStroke(_page))
            case .deviceCMYK:
                return Color(HPDF_Page_GetCMYKStroke(_page))
            case .deviceGray:
                return Color(gray: HPDF_Page_GetGrayStroke(_page))!
            default:
                return .white
            }
        }
        set {
            switch newValue._wrapped {
            case .cmyk(let color):
                HPDF_Page_SetCMYKStroke(_page,
                                        color.cyan,
                                        color.magenta,
                                        color.yellow,
                                        color.black)
            case .rgb(let color):
                HPDF_Page_SetRGBStroke(_page,
                                       color.red,
                                       color.green,
                                       color.blue)
            case .gray(let color):
                HPDF_Page_SetGrayStroke(_page, color)
            }
        }
    }
    
    /// The current value of the page's filling color. Default is RGB black.
    public var fillColor: Color {
        get {
            switch fillingColorSpace {
            case .deviceRGB:
                return Color(HPDF_Page_GetRGBFill(_page))
            case .deviceCMYK:
                return Color(HPDF_Page_GetCMYKFill(_page))
            case .deviceGray:
                return Color(gray: HPDF_Page_GetGrayFill(_page))!
            default:
                return .white
            }
        }
        set {
            switch newValue._wrapped {
            case .cmyk(let color):
                HPDF_Page_SetCMYKFill(_page,
                                      color.cyan,
                                      color.magenta,
                                      color.yellow,
                                      color.black)
            case .rgb(let color):
                HPDF_Page_SetRGBFill(_page,
                                     color.red,
                                     color.green,
                                     color.blue)
            case .gray(let color):
                HPDF_Page_SetGrayFill(_page, color)
            }
        }
    }
    
    // MARK: Path construction
    
    // In LibHaru we use state maching to switch between construction state and general state.
    // In SwiftyHaru calling path construction methods defers actual construction operations
    // until the moment the path is about to be drawn. It makes it easier for the end user.
    
    private enum _PathConstructionOperation {
        case moveTo(Point)
        case lineTo(Point)
        case arc(center: Point, radius: Float, beginningAngle: Float, endAngle: Float)
        case circle(center: Point, radius: Float)
        case rectangle(Rectangle)
        case curve(controlPoint1: Point, controlPoint2: Point, endPoint: Point)
        case curve2(controlPoint2: Point, endPoint: Point)
        case curve3(controlPoint1: Point, endPoint: Point)
        case ellipse(center: Point, xRadius: Float, yRadius: Float)
    }
    
    private var _pathConstructionSequence: [_PathConstructionOperation] = []
    
    private func _constructPath() {
        
        for operation in _pathConstructionSequence {
            
            switch operation {
            case .moveTo(let point):
                HPDF_Page_MoveTo(_page, point.x, point.y)
            case .lineTo(let point):
                HPDF_Page_LineTo(_page, point.x, point.y)
            case .arc(let center, let radius, let beginningAngle, let endAngle):
                HPDF_Page_Arc(_page, center.x, center.y, radius, beginningAngle, endAngle)
            case .circle(let center, let radius):
                HPDF_Page_Circle(_page, center.x, center.y, radius)
            case .rectangle(let rectangle):
                HPDF_Page_Rectangle(_page,
                                    rectangle.origin.x, rectangle.origin.y,
                                    rectangle.width, rectangle.height)
            case .curve(let controlPoint1, let controlPoint2, let endPoint):
                HPDF_Page_CurveTo(_page,
                                  controlPoint1.x, controlPoint1.y,
                                  controlPoint2.x, controlPoint2.y,
                                  endPoint.x, endPoint.y)
            case .curve2(let controlPoint2, let endPoint):
                HPDF_Page_CurveTo2(_page, controlPoint2.x, controlPoint2.y, endPoint.x, endPoint.y)
            case .curve3(let controlPoint1, let endPoint):
                HPDF_Page_CurveTo3(_page, controlPoint1.x, controlPoint1.y, endPoint.x, endPoint.y)
            case .ellipse(let center, let xRadius, let yRadius):
                HPDF_Page_Ellipse(_page, center.x, center.y, xRadius, yRadius)
            }
        }
        
        assert(currentPosition == Point(HPDF_Page_GetCurrentPos(_page)))
        
        _pathConstructionSequence = []
    }
    
    /// Starts a new subpath and moves the current point for drawing path,
    /// sets the start point for the path to the `point`.
    ///
    /// - parameter point: The start point for drawing path.
    public func move(to point: Point) {
        _currentPosition = point
        _pathConstructionSequence.append(.moveTo(point))
    }
    
    /// Starts a new subpath and moves the current point for drawing path,
    /// sets the start point for the path to the point with the specified coordinates.
    ///
    /// - parameter x: The x coordinate of th start point for drawing path.
    /// - parameter y: The y coordinate of th start point for drawing path.
    public func move(toX x: Float, y: Float) {
        move(to: Point(x: x, y: y))
    }
    
    /// Appends a path from the current point to the specified point. If this method has been called before
    /// setting the current position by calling `move(to:)`, then `Point.zero` is used as one.
    ///
    /// - parameter point: The end point of the path.
    public func line(to point: Point) {
        _currentPosition = point
        _pathConstructionSequence.append(.lineTo(point))
    }
    
    /// Appends a path from the current point to the specified point. If this method has been called before
    /// setting the current position by calling `move(to:)`, then `Point.zero` is used as one.
    ///
    /// - parameter x: The x coordinate of end point of the path.
    /// - parameter y: The y coordinate of end point of the path.
    public func line(toX x: Float, y: Float) {
        line(to: Point(x: x, y: y))
    }
    
    /// Appends a circle arc to the current path. Angles are given in degrees, with 0 degrees being vertical,
    /// upward.
    ///
    /// - parameter center:         The center point of the arc.
    /// - parameter radius:         The radius of the arc.
    /// - parameter beginningAngle: The angle of the begining of the arc.
    /// - parameter endAngle:       The angle of the end of the arc. It must be greater than `beginningAngle`.
    public func arc(center: Point, radius: Float, beginningAngle: Float, endAngle: Float) {
        _pathConstructionSequence.append(.arc(center: center,
                                              radius: radius,
                                              beginningAngle: beginningAngle,
                                              endAngle: endAngle))
    }
    
    /// Appends a circle arc to the current path. Angles are given in degrees, with 0 degrees being vertical,
    /// upward.
    ///
    /// - parameter x:              The x coordinate of the center point of the arc.
    /// - parameter y:              The y coordinate of the center point of the arc.
    /// - parameter radius:         The radius of the arc.
    /// - parameter beginningAngle: The angle of the begining of the arc.
    /// - parameter endAngle:       The angle of the end of the arc. It must be greater than `beginningAngle`.
    public func arc(x: Float, y: Float, radius: Float, beginningAngle: Float, endAngle: Float) {
        arc(center: Point(x: x, y: y), radius: radius, beginningAngle: beginningAngle, endAngle: endAngle)
    }
    
    /// Appends a circle to the current path.
    ///
    /// - parameter center: The center point of the circle.
    /// - parameter radius: The radius of the circle.
    public func circle(center: Point, radius: Float) {
        _pathConstructionSequence.append(.circle(center: center, radius: radius))
    }
    
    /// Appends a circle to the current path.
    ///
    /// - parameter x:      The x coordinate of the center point of the circle.
    /// - parameter y:      The y coordinate of the center point of the circle.
    /// - parameter radius: The radius of the circle.
    public func circle(x: Float, y: Float, radius: Float) {
        circle(center: Point(x: x, y: y), radius: radius)
    }
    
    /// Appends a rectangle to the current path.
    ///
    /// - parameter rect: The rectangle to append.
    public func rectangle(_ rect: Rectangle) {
        _pathConstructionSequence.append(.rectangle(rect))
    }
    
    /// Appends a rectangle to the current path.
    ///
    /// - parameter origin: The lower-left point of the rectangle.
    /// - parameter size:   The size of the rectangle.
    public func rectangle(origin: Point, size: Size) {
        rectangle(Rectangle(origin: origin, size: size))
    }
    
    /// Appends a rectangle to the current path.
    ///
    /// - parameter x:      The x coordinate of the lower-left point of the rectangle.
    /// - parameter y:      The y coordinate of the lower-left point of the rectangle.
    /// - parameter width:  The width of the rectangle.
    /// - parameter height: The height of the rectangle.
    func rectangle(x: Float, y: Float, width: Float, height: Float) {
        rectangle(origin: Point(x: x, y:y), size: Size(width: width, height: height))
    }
    
    /// Appends a Bézier curve to the current path using the control points `controlPoint1`,
    ///`controlPoint2` and `endPoint`, then sets the current point to `endPoint`.
    ///
    /// ![figure](http://libharu.org/figures/figure20.png "figure")
    ///
    /// - parameter controlPoint1: The first control point of the curve.
    /// - parameter controlPoint2: The second control point of the curve.
    /// - parameter endPoint: The end point of the curve.
    public func curve(controlPoint1: Point, controlPoint2: Point, endPoint: Point) {
        _currentPosition = endPoint
        _pathConstructionSequence.append(.curve(controlPoint1: controlPoint1,
                                                controlPoint2: controlPoint2,
                                                endPoint: endPoint))
    }
    
    /// Appends a Bézier curve to the current path using two spesified points.
    /// The point `controlPoint1` and the point `endPoint` are used as the control points for
    /// a Bézier curve and current point is moved to the point `endPoint.`
    ///
    /// ![figure](http://libharu.org/figures/figure22.png "figure")
    ///
    /// - parameter controlPoint1: The first control point of the curve.
    /// - parameter endPoint:      The end point of the curve.
    public func curve(controlPoint1: Point, endPoint: Point) {
        _currentPosition = endPoint
        _pathConstructionSequence.append(.curve3(controlPoint1: controlPoint1, endPoint: endPoint))
    }
    
    /// Appends a Bézier curve to the current path using the current point, `controlPoint2` and
    /// `endPoint` as control points. Then, the current point is set to `endPoint`.
    ///
    /// ![figure](http://libharu.org/figures/figure21.png "figure")
    ///
    /// - parameter controlPoint2: The second control point of the curve.
    /// - parameter endPoint:      The end point of the curve.
    public func curve(controlPoint2: Point, endPoint: Point) {
        _currentPosition = endPoint
        _pathConstructionSequence.append(.curve2(controlPoint2: controlPoint2, endPoint: endPoint))
    }
    
    /// Appends an ellipse to the current path.
    ///
    /// - parameter center:           The center point of the ellipse.
    /// - parameter horizontalRadius: The horizontal radius of the ellipse.
    /// - parameter verticalRadius:   The vertical radius of the ellipse.
    public func ellipse(center: Point, horizontalRadius: Float, verticalRadius: Float) {
        _pathConstructionSequence.append(.ellipse(center: center,
                                                  xRadius: horizontalRadius,
                                                  yRadius: verticalRadius))
    }
    
    /// Appends an ellipse to the current path.
    ///
    /// - parameter x:                The x coordinate of the center point of the ellipse.
    /// - parameter y:                The x coordinate of the center point of the ellipse.
    /// - parameter horizontalRadius: The horizontal radius of the ellipse.
    /// - parameter verticalRadius:   The vertical radius of the ellipse.
    public func ellipse(x: Float, y: Float, horizontalRadius: Float, verticalRadius: Float) {
        ellipse(center: Point(x: x, y: y), horizontalRadius: horizontalRadius, verticalRadius: verticalRadius)
    }
    
    /// Appends an ellipse to the current path.
    ///
    /// - parameter rectangle: The rectangle the ellipse should be inscribed in.
    public func ellipse(inscribedIn rectangle: Rectangle) {
        ellipse(center: rectangle.center, horizontalRadius: rectangle.width, verticalRadius: rectangle.height)
    }
    
    // MARK: - Path painting
    
    public func closePathFill(stroke: Bool, fill: Bool, evenOddRule: Bool) {
        
        _constructPath()
        
        Unimplemented()
    }
    
    /// Ends the path without filling or painting. Does nothing if no path is currently being constructed.
    public func endPath() {
        
        _constructPath()
        
        HPDF_Page_EndPath(_page)
    }
}
