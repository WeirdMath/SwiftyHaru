//
//  LineCap.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 07.10.16.
//
//

#if SWIFT_PACKAGE
import typealias CLibHaru.HPDF_LineCap
#endif

/// The shape to be used at the ends of lines.
///
/// - butt:             Line is squared off at path endpoint.
/// - round:            End of line becomes a semicircle whose center is at path endpoint.
/// - projectingSquare: Line continues beyond endpoint, goes on half the endpoint stroke width.
public enum LineCap: UInt32, CaseIterable {

    /// Line is squared off at path endpoint.
    ///
    /// ![Figure](http://libharu.org/figures/figure10.png "figure")
    case butt
    
    /// End of line becomes a semicircle whose center is at path endpoint.
    ///
    /// ![Figure](http://libharu.org/figures/figure11.png "figure")
    case round
    
    /// Line continues beyond endpoint, goes on half the endpoint stroke width.
    ///
    /// ![Figure](http://libharu.org/figures/figure12.png "figure")
    case projectingSquare
}

extension LineCap {
    
    internal init(_ haruEnum: HPDF_LineCap) {
        self.init(rawValue: haruEnum.rawValue)!
    }
}
