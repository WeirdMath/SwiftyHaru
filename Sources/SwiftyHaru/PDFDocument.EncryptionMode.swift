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

    /// The encryption mode to use for a document.
    public enum EncryptionMode: CaseIterable {

        /// Use "Revision 2" algorithm. The key length is set to 5 (40 bits).
        case r2

        /// Use "Revision 3" algorithm. The key length can be from 5 (40 bits) to 16 (128 bits).
        case r3(keyLength: Int)

        public static let allCases: [EncryptionMode] = [
            .r2,
            .r3(keyLength: 5),
            .r3(keyLength: 6),
            .r3(keyLength: 7),
            .r3(keyLength: 8),
            .r3(keyLength: 9),
            .r3(keyLength: 10),
            .r3(keyLength: 11),
            .r3(keyLength: 12),
            .r3(keyLength: 13),
            .r3(keyLength: 14),
            .r3(keyLength: 15),
            .r3(keyLength: 16)
        ]
    }
}
