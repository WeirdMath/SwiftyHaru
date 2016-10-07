//
//  PDFTextContext.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 07.10.16.
//
//

import CLibHaru

public final class PDFTextContext: PDFContext {
    
    internal override func _cleanup() {
        super._cleanup()
        
    }
    
    // MARK: - Text State
    
    public func set(font: Font, fontSize: Float) {
        Unimplemented()
    }
}
