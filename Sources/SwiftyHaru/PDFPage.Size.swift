//
//  PDFPage.Size.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 01.10.16.
//
//

extension PDFPage {
    
    /// A predefined size for a page.
    public enum Size: UInt32, CaseIterable {
        
        /// 8.5 x 11 inches
        case letter
        
        /// 8.5 x 14 inches
        case legal
        
        /// 297 x 420 mm
        case a3
        
        /// 210 x 297 mm
        case a4
        
        /// 148 x 210 mm
        case a5
        
        /// 250 x 353 mm
        case b4
        
        /// 176 x 250 mm
        case b5
        
        /// 7.25 x 10.5 inches
        case executive
        
        /// 4 x 6 inches
        case us4x6
        
        /// 4 x 8 inches
        case us4x8
        
        /// 5 x 7 inches
        case us5x7
        
        /// 4.125 x 9.5 inches
        case envelope10
    }
}

extension PDFPage.Size {

    /// The numeric value of the predefined size represented in pixels.
    public var sizeInPixels: Size {
        
        switch self {
        case .letter:        return     612 × 792
        case .legal:         return     612 × 1008
        case .a3:            return  841.89 × 1190.551
        case .a4:            return 595.276 × 841.89
        case .a5:            return 419.528 × 595.276
        case .b4:            return 708.661 × 1000.63
        case .b5:            return 498.898 × 708.661
        case .executive:     return     522 × 756
        case .us4x6:         return     288 × 432
        case .us4x8:         return     288 × 576
        case .us5x7:         return     360 × 504
        case .envelope10:    return     297 × 684
        }
    }
    
    /// The numeric value of the predefined size represented in inches.
    public var sizeInInches: Size {
        
        switch self {
        case .letter:        return     8.5 × 11
        case .legal:         return     8.5 × 14
        case .a3:            return 11.6929 × 16.5354
        case .a4:            return 8.26772 × 11.6929
        case .a5:            return 5.82677 × 8.26772
        case .b4:            return 9.84252 × 13.8976
        case .b5:            return 6.92913 × 9.84252
        case .executive:     return    7.25 × 10.5
        case .us4x6:         return       4 × 6
        case .us4x8:         return       4 × 8
        case .us5x7:         return       5 × 7
        case .envelope10:    return   4.125 × 9.5
        }
    }
    
    /// The numeric value of the predefined size represented in millimeters.
    public var sizeInMillimeters: Size {
        return (sizeInInches.width * 25.4) × (sizeInInches.height * 25.4)
    }
}
