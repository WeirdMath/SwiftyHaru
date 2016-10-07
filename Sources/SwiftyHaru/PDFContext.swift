//
//  PDFContext.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 07.10.16.
//
//

import CLibHaru

public class PDFContext {
    
    private var _pageHandle: HPDF_Page
    private var _isInvalidated = false
    
    internal final var _page: HPDF_Page {
        if _isInvalidated {
            fatalError("The context has been revoked.")
        }
        
        return _pageHandle
    }
    
    internal init(for page: HPDF_Page) {
        _pageHandle = page
    }
    
    internal func _cleanup() {
        
        // Reset to the default state
        
        lineWidth = 1
        strokeColor = .black
        fillColor = .black
        dashStyle = .straightLine
        lineCap = .butt
        lineJoin = .miter
        miterLimit = 10
    }
    
    internal func _invalidate() {
        _isInvalidated = true
    }
    
    // MARK: - Graphics state
    
    /// The current line width for path painting of the page. Default value is 1.
    public final var lineWidth: Float {
        get {
            return HPDF_Page_GetLineWidth(_page)
        }
        set {
            HPDF_Page_SetLineWidth(_page, newValue)
        }
    }
    
    /// The dash pattern for lines in the page.
    public final var dashStyle: DashStyle {
        get {
            return DashStyle(HPDF_Page_GetDash(_page))
        }
        set {
            let pattern = newValue.pattern.map(UInt16.init(_:))
            HPDF_Page_SetDash(_page,
                              pattern,
                              HPDF_UINT(pattern.count),
                              HPDF_UINT(pattern.isEmpty ? 0 : newValue.phase))
        }
    }
    
    /// The shape to be used at the ends of lines. Default value is `LineCap.buttEnd`.
    public final var lineCap: LineCap {
        get {
            return LineCap(HPDF_Page_GetLineCap(_page))
        }
        set {
            HPDF_Page_SetLineCap(_page, HPDF_LineCap(rawValue: newValue.rawValue))
        }
    }
    
    /// The line join style in the page. Default value is `LineJoin.miter`.
    public final var lineJoin: LineJoin {
        get {
            return LineJoin(HPDF_Page_GetLineJoin(_page))
        }
        set {
            HPDF_Page_SetLineJoin(_page, HPDF_LineJoin(rawValue: newValue.rawValue))
        }
    }
    
    /// The miter limit for the joins of connected lines. Minimum value is 1. Default value is 10.
    public final var miterLimit: Float {
        get {
            return HPDF_Page_GetMiterLimit(_page)
        }
        set {
            guard newValue >= 1 else { return }
            HPDF_Page_SetMiterLimit(_page, newValue)
        }
    }
    
    // MARK: - Color
    
    /// The current value of the page's stroking color space.
    public final var strokingColorSpace: PDFColorSpace {
        return PDFColorSpace(haruEnum: HPDF_Page_GetStrokingColorSpace(_page))
    }
    
    /// The current value of the page's filling color space.
    public final var fillingColorSpace: PDFColorSpace {
        return PDFColorSpace(haruEnum: HPDF_Page_GetFillingColorSpace(_page))
    }
    
    /// The current value of the page's stroking color. Default is RGB black.
    public final var strokeColor: Color {
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
    public final var fillColor: Color {
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

}
