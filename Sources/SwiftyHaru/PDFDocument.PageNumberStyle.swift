//
//  PDFDocument.PageNumberStyle.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 02.10.16.
//
//

import CLibHaru

public extension PDFDocument {
    
    /// Determines a page labeling style of the document.
    public enum PageNumberStyle: UInt32 {
        
        /// Arabic numerals (1 2 3 4).
        case decimal
        
        /// Uppercase roman numerals (I II III IV).
        case upperRoman
        
        /// Lowercase roman numerals (i ii iii iv).
        case lowerRoman
        
        /// Uppercase letters (A B C D).
        case upperLetters
        
        ///  Lowercase letters (a b c d).
        case lowerLetters
    }
}

extension PDFDocument.PageNumberStyle {
    
    internal init(haruEnum: HPDF_PageNumStyle) {
        self.init(rawValue: haruEnum.rawValue)!
    }
}
