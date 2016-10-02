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
    
    internal func finalize() {
        
        // If by the this method is called the `_page` object's graphics mode is not HPDF_GMODE_PAGE_DESCRIPTION,
        // one of the path painting operators is invoked automatically during this method call.
        // Also during this method call all the graphics properties of the page like line width or stroke color
        // are set to their default values.
        
        // Reset to default state
        
        move(to: (x: 0, y: 0))
        
        HPDF_Page_EndPath(_page)
        
        // By this time graphics mode is HPDF_GMODE_PAGE_DESCRIPTION
        
        lineWidth = 1
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
    
    /// The current position for path painting. Default value is (x: 0, y: 0)
    public var currentPosition: Point {
        
        let point = HPDF_Page_GetCurrentPos(_page)
        
        return _Point(point)
    }
    
    /// The current value of the page's stroking color space.
    public var strokingColorSpace: PDFColorSpace {
        return PDFColorSpace(haruEnum: HPDF_Page_GetStrokingColorSpace(_page))
    }
    
    /// The current value of the page's filling color space.
    public var fillingColorSpace: PDFColorSpace {
        return PDFColorSpace(haruEnum: HPDF_Page_GetFillingColorSpace(_page))
    }
    
    private var _strokeColor: Color?
    
    /// The current value of the page's stroking color.
    public var strokeColor: Color {
        get {
            
            if let strokeColor = _strokeColor {
                return strokeColor
            }
            
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
            
            // If the current graphics mode is not appropriate for setting color, defer it
            // until we switch to the HPDF_GMODE_PAGE_DESCRIPTION mode
            if Int32(HPDF_Page_GetGMode(_page)) != HPDF_GMODE_PAGE_DESCRIPTION  {
                _strokeColor = newValue
                return
            }
            
            switch strokingColorSpace {
            case .deviceCMYK:
                HPDF_Page_SetCMYKStroke(_page,
                                        newValue.cyan,
                                        newValue.magenta,
                                        newValue.yellow,
                                        newValue.black)
            case .deviceGray:
                if newValue.isGray {
                    HPDF_Page_SetGrayStroke(_page, newValue.red)
                } else {
                    HPDF_Page_SetRGBStroke(_page, newValue.red, newValue.green, newValue.blue)
                }
            default:
                HPDF_Page_SetRGBStroke(_page, newValue.red, newValue.green, newValue.blue)
            }
        }
    }
    
    private var _fillColor: Color?
    
    /// The current value of the page's filling color.
    public var fillColor: Color {
        get {
            
            if let fillColor = _fillColor {
                return fillColor
            }
            
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
            
            // If the current graphics mode is not appropriate for setting color, defer it
            // until we switch to the HPDF_GMODE_PAGE_DESCRIPTION mode
            if Int32(HPDF_Page_GetGMode(_page)) != HPDF_GMODE_PAGE_DESCRIPTION  {
                _fillColor = newValue
                return
            }
            
            switch fillingColorSpace {
            case .deviceCMYK:
                HPDF_Page_SetCMYKFill(_page,
                                        newValue.cyan,
                                        newValue.magenta,
                                        newValue.yellow,
                                        newValue.black)
            case .deviceGray:
                if newValue.isGray {
                    HPDF_Page_SetGrayFill(_page, newValue.red)
                } else {
                    HPDF_Page_SetRGBFill(_page, newValue.red, newValue.green, newValue.blue)
                }
            default:
                HPDF_Page_SetRGBFill(_page, newValue.red, newValue.green, newValue.blue)
            }
        }
    }
    
    // MARK: Path construction
    
    /// Starts a new subpath and moves the current point for drawing path,
    /// sets the start point for the path to the `point`.
    ///
    /// - parameter point: The start point for drawing path
    public func move(to point: Point) {
        
        HPDF_Page_MoveTo(_page, point.x, point.y)
        
        // By this time graphics mode is HPDF_GMODE_PATH_OBJECT
    }
    
    /// Appends a path from the current point to the specified point. If this method has been called before
    /// setting the current position by calling `move(to:)`, then (x: 0, y: 0) is used as one.
    ///
    /// - parameter point: The end point of the path.
    public func line(to point: Point) {
        
        if Int32(HPDF_Page_GetGMode(_page)) != HPDF_GMODE_PATH_OBJECT {
            HPDF_Page_MoveTo(_page, 0, 0)
        }
        
        // By this time graphics mode is HPDF_GMODE_PATH_OBJECT
        
        HPDF_Page_LineTo(_page, point.x, point.y)
    }
    
    // MARK: - Path painting
    
    public func closePathFill(stroke: Bool, fill: Bool, evenOddRule: Bool) {
        
        Unimplemented()
        
        // By this time graphics mode is HPDF_GMODE_PAGE_DESCRIPTION,
        // so we can set the stroke and fill colors
        
        if let strokeColor = _strokeColor {
            HPDF_Page_SetRGBStroke(_page, strokeColor.red, strokeColor.green, strokeColor.blue)
            _strokeColor = nil
        }
        
        if let fillColor = _fillColor {
            HPDF_Page_SetRGBFill(_page, fillColor.red, fillColor.green, fillColor.blue)
            _fillColor = nil
        }
    }
    
    /// Ends the path without filling or painting. Does nothing if no path is currently being constructed.
    public func endPath() {
        
        guard Int32(HPDF_Page_GetGMode(_page)) == HPDF_GMODE_PATH_OBJECT else {
            return
        }
        
        HPDF_Page_EndPath(_page)
        
        // By this time graphics mode should be HPDF_GMODE_PAGE_DESCRIPTION or HPDF_GMODE_TEXT_OBJECT
        // so we can set the stroke and fill colors
        
        if let strokeColor = _strokeColor {
            HPDF_Page_SetRGBStroke(_page, strokeColor.red, strokeColor.green, strokeColor.blue)
            _strokeColor = nil
        }
        
        if let fillColor = _fillColor {
            HPDF_Page_SetRGBFill(_page, fillColor.red, fillColor.green, fillColor.blue)
            _fillColor = nil
        }
    }
}
