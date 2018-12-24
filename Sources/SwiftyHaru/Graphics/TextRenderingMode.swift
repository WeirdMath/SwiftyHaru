//
//  TextRenderingMode.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 25/12/2018.
//

#if SWIFT_PACKAGE
import CLibHaru
#endif

/// A mode for rendering text.
///
/// Text drawing modes determine how SwiftyHaru renders individual glyphs. For example, you can
/// set a text drawing mode to draw text filled in or outlined (stroked) or both.
/// You can also create special effects with the text clipping drawing modes, such as clipping
/// an image to a glyph shape.
public enum TextRenderingMode: UInt32, CaseIterable {

    /// Perform a fill operation on the text.
    ///
    /// ![Figure](http://libharu.org/figures/figure23.png "figure")
    case fill = 0

    /// Perform a stroke operation on the text.
    ///
    /// ![Figure](http://libharu.org/figures/figure24.png "figure")
    case stroke

    /// Perform fill, then stroke operations on the text.
    ///
    /// ![Figure](http://libharu.org/figures/figure25.png "figure")
    case fillThenStroke

    /// Do not draw the text, but do update the text position.
    case invisible

    /// Perform a fill operation, then intersect the text with the current clipping path.
    ///
    /// ![Figure](http://libharu.org/figures/figure26.png "figure")
    case fillClipping

    /// Perform a stroke operation, then intersect the text with the current clipping path.
    ///
    /// ![Figure](http://libharu.org/figures/figure27.png "figure")
    case strokeClipping

    /// Perform fill then stroke operations, then intersect the text with the current clipping path.
    ///
    /// ![Figure](http://libharu.org/figures/figure28.png "figure")
    case fillStrokeClipping

    /// Specifies to intersect the text with the current clipping path. This mode does not paint the text.
    case clipping
}

extension TextRenderingMode {
    internal init(_ haruEnum: HPDF_TextRenderingMode) {
        self.init(rawValue: haruEnum.rawValue)!
    }
}
