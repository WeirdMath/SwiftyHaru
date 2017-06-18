//
//  TextAlignment.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 04.06.2017.
//
//

import CLibHaru

public enum TextAlignment: UInt32 {

    /// The text is aligned to left.
    case left

    /// The text is aligned to right.
    case right

    /// The text is aligned to center.
    case center

    /// Add spaces between the words to justify both left and right side.
    case justify
}

extension TextAlignment {

    internal init(haruEnum: HPDF_TextAlignment) {
        self.init(rawValue: haruEnum.rawValue)!
    }
}
