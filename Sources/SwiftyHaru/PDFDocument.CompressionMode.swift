//
//  PDFDocument.CompressionMode.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 04.06.2017.
//
//

import CLibHaru

extension PDFDocument {

    /// The mode of compression for a document.
    public struct CompressionMode : OptionSet {

        public let rawValue: Int32

        public init(rawValue: Int32) {
            self.rawValue = rawValue
        }

        /// No compression
        public static let none = CompressionMode(rawValue: HPDF_COMP_NONE)

        /// Compress the contents stream of the page.
        public static let text = CompressionMode(rawValue: HPDF_COMP_TEXT)

        /// Compress the streams of the image objects.
        public static let image = CompressionMode(rawValue: HPDF_COMP_IMAGE)

        /// Other stream datas (fonts, cmaps and so on) are compressed.
        public static let metadata = CompressionMode(rawValue: HPDF_COMP_METADATA)

        /// All stream datas are compressed.
        public static let all = CompressionMode(rawValue: HPDF_COMP_ALL)
    }
}
