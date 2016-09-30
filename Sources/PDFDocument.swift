//
//  PDFDocument.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 30.09.16.
//
//

import CLibHaru

public final class PDFDocument: _HaruBridgeable {
    
    internal var _haruObject: HPDF_Doc
    
    public init() throws {
        
        var error = PDFError(code: 0)
        
        func errorHandler(errorCode: HPDF_STATUS,
                          detailCode: HPDF_STATUS,
                          userData: UnsafeMutableRawPointer?) {
            
            let error = userData?.assumingMemoryBound(to: PDFError.self)
            error?.pointee = PDFError(code: Int32(errorCode))
        }
        
        guard let document = HPDF_New(errorHandler, &error) else { throw error }
        
        _haruObject = document
    }
    
    deinit {
        HPDF_Free(_haruObject)
    }
}
