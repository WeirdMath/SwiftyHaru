//
//  LineJoin.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 07.10.16.
//
//

import typealias CLibHaru.HPDF_LineJoin

/// Line join style.
///
/// - miter: A join with a sharp (angled) corner.
/// - round: A join with a rounded end.
/// - bevel: A join with a squared-off end.
public enum LineJoin: UInt32 {
    
    /// A join with a sharp (angled) corner.
    ///
    /// ![Figure](http://libharu.org/figures/figure13.png "figure")
    case miter
    
    /// A join with a rounded end.
    ///
    /// ![Figure](http://libharu.org/figures/figure14.png "figure")
    case round
    
    /// A join with a squared-off end.
    ///
    /// ![Figure](http://libharu.org/figures/figure15.png "figure")
    case bevel
}

internal extension LineJoin {
    
    internal init(_ haruEnum: HPDF_LineJoin) {
        self.init(rawValue: haruEnum.rawValue)!
    }
}
