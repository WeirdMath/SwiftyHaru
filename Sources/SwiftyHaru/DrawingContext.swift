//
//  DrawingContext.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 02.10.16.
//
//

import CLibHaru

public final class DrawingContext {
    
    private var __page: HPDF_Page
    private var _documentHandle: HPDF_Doc
    private var _isInvalidated = false
    
    internal var _page: HPDF_Page {
        if _isInvalidated {
            fatalError("The context has been revoked.")
        }
        
        return __page
    }
    
    internal init(for page: HPDF_Page, document: HPDF_Doc) {
        
        _documentHandle = document
        __page = page
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
        
        let font = HPDF_GetFont(_documentHandle, Font.helvetica.name, Encoding.standard.name)
        HPDF_Page_SetFontAndSize(__page, font, 11)
    }
    
    internal func _invalidate() {
        _isInvalidated = true
    }
    
    // MARK: - Graphics state
    
    /// The current line width for path painting of the page. Default value is 1.
    public var lineWidth: Float {
        get {
            return HPDF_Page_GetLineWidth(_page)
        }
        set {
            HPDF_Page_SetLineWidth(_page, newValue)
        }
    }
    
    /// The dash pattern for lines in the page.
    public var dashStyle: DashStyle {
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
    public var lineCap: LineCap {
        get {
            return LineCap(HPDF_Page_GetLineCap(_page))
        }
        set {
            HPDF_Page_SetLineCap(_page, HPDF_LineCap(rawValue: newValue.rawValue))
        }
    }
    
    /// The line join style in the page. Default value is `LineJoin.miter`.
    public var lineJoin: LineJoin {
        get {
            return LineJoin(HPDF_Page_GetLineJoin(_page))
        }
        set {
            HPDF_Page_SetLineJoin(_page, HPDF_LineJoin(rawValue: newValue.rawValue))
        }
    }
    
    /// The miter limit for the joins of connected lines. Minimum value is 1. Default value is 10.
    public var miterLimit: Float {
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
    
    
    // MARK: - Path construction
    
    // In LibHaru we use state maching to switch between construction state and general state.
    // In SwiftyHaru calling path construction methods defers actual construction operations
    // until the moment the path is about to be drawn. It makes it easier for the end user.
    
    private func _construct(_ path: Path) {
        
        for operation in path._pathConstructionSequence {
            
            switch operation {
            case .moveTo(let point):
                HPDF_Page_MoveTo(_page, point.x, point.y)
            case .lineTo(let point):
                HPDF_Page_LineTo(_page, point.x, point.y)
            case .closePath:
                HPDF_Page_ClosePath(_page)
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
        
        assert(path.currentPosition == Point(HPDF_Page_GetCurrentPos(_page)))
    }
    
    // MARK: - Path painting
    
    /// Fills the `path`.
    ///
    /// - parameter path:        The path to fill.
    /// - parameter evenOddRule: If specified `true`, fills the path using the even-odd rule.
    ///                          Otherwise fills it using the nonzero winding number rule.
    ///                          Default value is `false`.
    /// - parameter stroke:      If specified `true`, also paints the path itself. Default value is `false`.
    public func fill(_ path: Path, evenOddRule: Bool = false, stroke: Bool = false) {
        
        assert(Int32(HPDF_Page_GetGMode(_page)) == HPDF_GMODE_PAGE_DESCRIPTION)
        
        _construct(path)
        
        assert(Int32(HPDF_Page_GetGMode(_page)) == HPDF_GMODE_PATH_OBJECT)
        
        switch (evenOddRule, stroke) {
        case (true, true):
            HPDF_Page_EofillStroke(_page)
        case (true, false):
            HPDF_Page_Eofill(_page)
        case (false, true):
            HPDF_Page_FillStroke(_page)
        case (false, false):
            HPDF_Page_Fill(_page)
        }
        
        assert(Int32(HPDF_Page_GetGMode(_page)) == HPDF_GMODE_PAGE_DESCRIPTION)
    }
    
    /// Paints the `path`.
    ///
    /// - parameter path: The path to paint.
    public func stroke(_ path: Path) {
        
        assert(Int32(HPDF_Page_GetGMode(_page)) == HPDF_GMODE_PAGE_DESCRIPTION)
        
        _construct(path)
        
        assert(Int32(HPDF_Page_GetGMode(_page)) == HPDF_GMODE_PATH_OBJECT)
        
        HPDF_Page_Stroke(_page)
        
        assert(Int32(HPDF_Page_GetGMode(_page)) == HPDF_GMODE_PAGE_DESCRIPTION)
    }
    
    // MARK: - Text state
    
    /// Tha current font of the context.
    public var font: Font {
        get {
            let fontHandle = HPDF_Page_GetCurrentFont(_page)
            return Font(name: String(cString: HPDF_Font_GetFontName(fontHandle)))
        }
        set {
            let font = HPDF_GetFont(_documentHandle, newValue.name, encoding.name)
            
            HPDF_Page_SetFontAndSize(_page, font, fontSize)
        }
    }
    
    /// The maximum size of a font that can be set.
    public var maximumFontSize: Float {
        return Float(HPDF_MAX_FONTSIZE)
    }
    
    /// The size of the current font of the context. Valid values are between 0 and `maximumFontSize`.
    /// Setting an invalid value makes mo change. Default value is 11.
    public var fontSize: Float {
        get {
            return HPDF_Page_GetCurrentFontSize(_page)
        }
        set {
            guard newValue > 0 && newValue < maximumFontSize else { return }
            
            let font = HPDF_GetFont(_documentHandle, self.font.name, encoding.name)
            
            HPDF_Page_SetFontAndSize(_page, font, newValue)
        }
    }
    
    /// The encoding to use for a text.
    public var encoding: Encoding {
        get {
            let font = HPDF_Page_GetCurrentFont(_page)
            let encodingName = HPDF_Font_GetEncodingName(font)!
            return Encoding(name: String(cString: encodingName))
        }
        set {
            _enableMultibyteEncoding(for: newValue)
            let font = HPDF_GetFont(_documentHandle, self.font.name, newValue.name)
            HPDF_Page_SetFontAndSize(_page, font, fontSize)
        }
    }
    
    private func _enableMultibyteEncoding(for encoding: Encoding) {
        
        switch encoding {
        case Encoding.gbEucCnHorisontal,
             Encoding.gbEucCnVertical,
             Encoding.gbkEucHorisontal,
             Encoding.gbkEucVertical:
            HPDF_UseCNSEncodings(_documentHandle)
        case Encoding.eTenB5Vertical,
             Encoding.eTenB5Horisontal:
            HPDF_UseCNTEncodings(_documentHandle)
        case Encoding.rksjHorisontal,
             Encoding.rksjVertical,
             Encoding.rksjHorisontalProportional,
             Encoding.eucHorisontal,
             Encoding.eucVertical:
            HPDF_UseJPEncodings(_documentHandle)
        case Encoding.kscEucHorisontal,
             Encoding.kscEucVertical,
             Encoding.kscMsUhcProportional,
             Encoding.kscMsUhsVerticalFixedWidth,
             Encoding.kscMsUhsHorisontalFixedWidth:
            HPDF_UseKREncodings(_documentHandle)
        default:
            return
        }
    }
    
    /// Gets the width of the text in current fontsize, character spacing and word spacing.
    ///
    /// - parameter text:  The text to get width of.
    ///
    /// - returns: The width of the text in current fontsize, character spacing and word spacing.
    public func textWidth(for text: String) -> Float {
        return HPDF_Page_TextWidth(_page, text)
    }
    
    // MARK: - Text showing
    
    /// Prints the text at the specified position position on the page.
    ///
    /// - parameter text: The text to print.
    /// - parameter position: The position to show the text at.
    public func show(text: String, atPosition position: Point) {
        
        HPDF_Page_BeginText(_page)
        
        let currentTextPosition = Point(HPDF_Page_GetCurrentTextPos(_page))
        let offsetFromCurrentToSpecifiedPosition = position - currentTextPosition
        HPDF_Page_MoveTextPos(_page,
                              offsetFromCurrentToSpecifiedPosition.x,
                              offsetFromCurrentToSpecifiedPosition.y)
        
        HPDF_Page_ShowText(_page, text)
        
        HPDF_Page_EndText(_page)
    }
}
