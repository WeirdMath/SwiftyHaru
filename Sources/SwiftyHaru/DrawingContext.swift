//
//  DrawingContext.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 02.10.16.
//
//

import CLibHaru
import Foundation

public final class DrawingContext {
    
    private weak var _document: PDFDocument?
    private var __page: HPDF_Page
    private var _documentHandle: HPDF_Doc
    private var _isInvalidated = false
    
    internal var _page: HPDF_Page {
        if _isInvalidated {
            fatalError("The context has been revoked.")
        }
        
        return __page
    }
    
    internal init(for page: PDFPage) {
        
        __page = page._pageHandle
        
        _document = page.document
        
        _documentHandle = _document!._documentHandle
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
        
        textLeading = 11
    }
    
    internal func _invalidate() {
        _isInvalidated = true
    }
    
    // MARK: - Graphics state
    
    /// The current line width for path painting of the page. Must be nonegative. Default value is 1.
    public var lineWidth: Float {
        get {
            return HPDF_Page_GetLineWidth(_page)
        }
        set {
            guard newValue >= 0 else { return }
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
    
    /// The number of the page's graphics state stack.
    ///
    /// This number is increased whenever you call `withNewGState(_:)` or
    /// `clip(to:evenOddRule:_:)` and decreased as soon as such a function returns.
    ///
    /// The maximum value of this property is `DrawingContext.maxGraphicsStateDepth`.
    public var graphicsStateDepth: Int {
        return Int(HPDF_Page_GetGStateDepth(_page))
    }
    
    /// The maximum depth of the graphics state stack.
    public static var maxGraphicsStateDepth: Int {
        return Int(HPDF_LIMIT_MAX_GSTATE)
    }

    /// Saves the page's current graphics state to the stack, then executes `body`,
    /// then restores the saved graphics state.
    ///
    /// - Important: Inside the provided block the value of `graphicsStateDepth` is incremented.
    ///              Check it to prevent throwing the `PDFError.exceedGStateLimit` error.
    ///
    /// The parameters that are saved at the beginning of the call and restored at the end are:
    ///
    ///    - Character Spacing
    ///    - Clipping Path
    ///    - Dash Mode
    ///    - Filling Color
    ///    - Flatness
    ///    - Font
    ///    - Font Size
    ///    - Horizontal Scalling
    ///    - Line Width
    ///    - Line Cap Style
    ///    - Line Join Style
    ///    - Miter Limit
    ///    - Rendering Mode
    ///    - Stroking Color
    ///    - Text Leading
    ///    - Text Rise
    ///    - Transformation Matrix
    ///    - Word Spacing
    ///
    ///
    /// Example:
    /// ```swift
    /// assert(context.fillColor == .red)
    ///
    /// try context.withNewGState {
    ///
    ///    context.fillColor = .blue
    ///    assert(context.fillColor == .blue)
    /// }
    ///
    /// assert(context.fillColor == .red)
    /// ```
    ///
    /// - Parameter body: The code to execute using a new graphics state.
    /// - Throws:         `PDFError.exceedGStateLimit` if `graphicsStateDepth` is greater than
    ///                   `DrawingContext.maxGraphicsStateDepth`;
    ///                   rethrows errors thrown by `body`.
    public func withNewGState(_ body: () throws -> Void) throws {

        if HPDF_Page_GSave(_page) != UInt(HPDF_OK) {
            HPDF_ResetError(_documentHandle)
            throw PDFError.exceedGStateLimit
        }

        try body()

        HPDF_Page_GRestore(_page)
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
        
        assert(path.currentPosition.x - HPDF_Page_GetCurrentPos(_page).x < 0.001 &&
               path.currentPosition.y - HPDF_Page_GetCurrentPos(_page).y < 0.001,
               "The value of property `currentPosition` (\(path.currentPosition)) is not equal to " +
               "the value returned from the function " +
               "`HPDF_Page_GetCurrentPos` (\(HPDF_Page_GetCurrentPos(_page)))")
        
        HPDF_Page_MoveTo(_page, 0, 0)
    }
    
    // MARK: - Path painting
    
    /// Sets the clipping area for drawing.
    ///
    /// - Important: Inside the provided block the value of `graphicsStateDepth` is incremented.
    ///              Check it to prevent throwing the `PDFError.exceedGStateLimit` error.
    ///
    /// - Important: Graphics parameters that are set inside the `drawInsideClippingArea` closure do not
    ///              persist outside the call of that closure. I. e. if, for example, the context's fill color
    ///              had been black
    ///              and then was set to red inside the `drawInsideClippingArea` closure, after the closure
    ///              returns it is black again.
    ///
    /// - parameter path:                   The path that constraints the clipping area. Must be closed.
    /// - parameter evenOddRule:            If `true`, uses even-odd rule for specifying a clipping area.
    ///                                     Otherwise uses nonzero winding number rule.
    /// - parameter drawInsideClippingArea: All that is drawn inside this closure is clipped to the
    ///                                     provided `path`.
    /// - Throws:         `PDFError.exceedGStateLimit` if `graphicsStateDepth` is greater than
    ///                   `DrawingContext.maxGraphicsStateDepth`;
    ///                   rethrows errors thrown by the`drawInsideClippingArea` block.
    public func clip(to path: Path, evenOddRule: Bool = false,
                     _ drawInsideClippingArea: () throws -> Void) throws {
        
        try withNewGState {
            
            _construct(path)
            
            HPDF_Page_ClosePath(_page)
            
            if evenOddRule {
                HPDF_Page_Eoclip(_page)
            } else {
                HPDF_Page_Clip(_page)
            }
            
            HPDF_Page_EndPath(_page)
            
            try drawInsideClippingArea()
        }
    }
    
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
    
    /// The encoding to use for a text. If the encoding cannot be used with the specified font, does nothing.
    public var encoding: Encoding {
        get {
            let font = HPDF_Page_GetCurrentFont(_page)
            let encodingName = HPDF_Font_GetEncodingName(font)!
            return Encoding(name: String(cString: encodingName))
        }
        set {
            _enableMultibyteEncoding(for: newValue)
            
            let font = HPDF_GetFont(_documentHandle, self.font.name, newValue.name)
            
            if let font = font {
                HPDF_Page_SetFontAndSize(_page, font, fontSize)
            } else {
                HPDF_ResetError(_documentHandle)
            }
        }
    }
    
    private func _enableMultibyteEncoding(for encoding: Encoding) {
        
        switch encoding {
        case Encoding.gbEucCnHorisontal,
             Encoding.gbEucCnVertical,
             Encoding.gbkEucHorisontal,
             Encoding.gbkEucVertical:
            _document?._useCNSEncodings()
        case Encoding.eTenB5Vertical,
             Encoding.eTenB5Horisontal:
            _document?._useCNTEncodings()
        case Encoding.rksjHorisontal,
             Encoding.rksjVertical,
             Encoding.rksjHorisontalProportional,
             Encoding.eucHorisontal,
             Encoding.eucVertical:
            _document?._useJPEncodings()
        case Encoding.kscEucHorisontal,
             Encoding.kscEucVertical,
             Encoding.kscMsUhcProportional,
             Encoding.kscMsUhsVerticalFixedWidth,
             Encoding.kscMsUhsHorisontalFixedWidth:
            _document?._useKREncodings()
        case Encoding.utf8:
            _document?._useUTFEncodings()
        default:
            return
        }
    }
    
    /// Gets the width of the text in the current fontsize, character spacing and word spacing. If the text
    /// is multiline, returns the width of the longest line.
    ///
    /// - parameter text:  The text to get width of.
    ///
    /// - returns: The width of the text in current fontsize, character spacing and word spacing.
    public func textWidth(for text: String) -> Float {
        
        let lines = text.components(separatedBy: .newlines)
        
        return lines.map { HPDF_Page_TextWidth(_page, $0) }.max()!
    }
    
    /// Gets the bounding box of the text in the current font size and leading. Text can be multiline.
    ///
    /// - parameter text:     The text to get the bounding box of.
    /// - parameter position: The assumed position of the text.
    ///
    /// - returns: The bounding box of the text.
    public func boundingBox(for text: String, atPosition position: Point) -> Rectangle {
        
        let textWidth = self.textWidth(for: text)
        
        let numberOfLines = text.components(separatedBy: .newlines).count
        
        return Rectangle(x: position.x,
                         y: position.y + fontDescent - textLeading * Float(numberOfLines - 1),
                         width: textWidth,
                         height: fontAscent - fontDescent + textLeading * Float(numberOfLines - 1))
    }
    
    /// The vertical ascent of the current font in the current font size.
    public var fontAscent: Float {
        
        let fontHandle = HPDF_GetFont(_documentHandle, font.name, encoding.name)
        
        return Float(HPDF_Font_GetAscent(fontHandle)) * fontSize / 1000
    }
    
    /// The vertical descent of the current font in the current font size. This value is negative.
    public var fontDescent: Float {
        
        let fontHandle = HPDF_GetFont(_documentHandle, font.name, encoding.name)
        
        return Float(HPDF_Font_GetDescent(fontHandle)) * fontSize / 1000
    }
    
    /// The height of lowercase letters reach based on height of lowercase x in the current font and font size;
    /// does not include ascenders or descenders.
    public var fontXHeight: Float {
        
        let fontHandle = HPDF_GetFont(_documentHandle, font.name, encoding.name)
        
        return Float(HPDF_Font_GetXHeight(fontHandle)) * fontSize / 1000
    }
    
    /// The height of a capital letter in the current font and font size measured from the baseline.
    public var fontCapHeight: Float {
        
        let fontHandle = HPDF_GetFont(_documentHandle, font.name, encoding.name)
        
        return Float(HPDF_Font_GetCapHeight(fontHandle)) * fontSize / 1000
    }
    
    /// Text leading (line spacing) for text showing. Default value is 11.
    public var textLeading: Float {
        get {
            return HPDF_Page_GetTextLeading(_page)
        }
        set {
            HPDF_Page_SetTextLeading(_page, newValue)
        }
    }
    
    // MARK: - Text showing
    
    private func moveTextPosition(to point: Point) {
        
        let currentTextPosition = Point(HPDF_Page_GetCurrentTextPos(_page))
        let offsetFromCurrentToSpecifiedPosition = point - currentTextPosition
        HPDF_Page_MoveTextPos(_page,
                              offsetFromCurrentToSpecifiedPosition.x,
                              offsetFromCurrentToSpecifiedPosition.y)
    }
    
    /// Prints the text at the specified position on the page. You can use "\n" to print multiline text.
    ///
    /// - parameter text: The text to print.
    /// - parameter position: The position to show the text at.
    public func show(text: String, atPosition position: Point) {
        
        HPDF_Page_BeginText(_page)
        
        moveTextPosition(to: position)
        
        let lines = text.components(separatedBy: .newlines)
        
        HPDF_Page_ShowText(_page, lines.first!)
        
        for line in lines.dropFirst() {
            HPDF_Page_ShowTextNextLine(_page, line)
        }
        
        HPDF_Page_EndText(_page)
    }
    
    /// Prints the text at the specified position on the page. You can use "\n" to print multiline text.
    ///
    /// - parameter text: The text to print.
    /// - parameter x:    x coordinate of the position to show the text at.
    /// - parameter y:    y coordinate of the position to show the text at.
    public func show(text: String, atX x: Float, y: Float) {
        show(text: text, atPosition: Point(x: x, y: y))
    }

    /// Prints the text inside the specified region.
    ///
    /// - Parameters:
    ///   - text:      The text to show.
    ///   - rect:      The region to output text.
    ///   - alignment: The alignment of the text.
    /// - Returns:    
    ///     - `isSufficientSpace`: `false` if whole text doesn't fit into declared space.
    ///     - `charactersPrinted`: The number of characters printed in the area.
    public func show(text: String,
                     in rect: Rectangle,
                     alignment: TextAlignment) -> (isSufficientSpace: Bool, charactersPrinted: Int) {

        HPDF_Page_BeginText(_page)

        defer {
            HPDF_Page_EndText(_page)
        }

        var charactersPrinted: HPDF_UINT = 0

        let status = HPDF_Page_TextRect(_page,
                                        rect.x, rect.maxY, rect.maxX, rect.y,
                                        text,
                                        HPDF_TextAlignment(rawValue: alignment.rawValue), &charactersPrinted)

        return (isSufficientSpace: status != UInt(HPDF_PAGE_INSUFFICIENT_SPACE),
                charactersPrinted: Int(charactersPrinted))
    }
}
