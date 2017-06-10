//
//  PDFDocument.EncryptionMode.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 04.06.2017.
//
//

#if SWIFT_PACKAGE
import CLibHaru
#endif

extension PDFDocument {

    public enum EncryptionMode {

        /// Use "Revision 2" algorithm. The key length is set to 5 (40 bits).
        case r2

        /// Use "Revision 3" algorithm. The key length can be from 5 (40 bits) to 16 (128 bits).
        case r3(keyLength: Int)
    }
}
