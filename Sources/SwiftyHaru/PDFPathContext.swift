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
                                        color.magenta,
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
                                        color.magenta,
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
    }
    
    private var _pathConstructionSequence: [_PathConstructionOperation] = []
    
    private func _constructPath() {
        
        for operation in _pathConstructionSequence {
            
            switch operation {
            case .moveTo(let point):
                HPDF_Page_MoveTo(_page, point.x, point.y)
            case .lineTo(let point):
                HPDF_Page_LineTo(_page, point.x, point.y)
            }
            
            assert(currentPosition == Point(HPDF_Page_GetCurrentPos(_page)))
        }
        
        _pathConstructionSequence = []
    }
    
    /// Starts a new subpath and moves the current point for drawing path,
    /// sets the start point for the path to the `point`.
    ///
    /// - parameter point: The start point for drawing path
    public func move(to point: Point) {
        _currentPosition = point
        _pathConstructionSequence.append(.moveTo(point))
    }
    
    /// Appends a path from the current point to the specified point. If this method has been called before
    /// setting the current position by calling `move(to:)`, then `Point.zero` is used as one.
    ///
    /// - parameter point: The end point of the path.
    public func line(to point: Point) {
        _currentPosition = point
        _pathConstructionSequence.append(.moveTo(point))
    }
    
    // MARK: - Path painting
    
    public func closePathFill(stroke: Bool, fill: Bool, evenOddRule: Bool) {
        
        _constructPath()
        
        Unimplemented()
    }
    
    /// Ends the path without filling or painting. Does nothing if no path is currently being constructed.
    public func endPath() {
        _pathConstructionSequence = []
    }
}
