//
//  PDFDocument.Permissions.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 04.06.2017.
//
//

import CLibHaru

extension PDFDocument {

    /// Permission flags to use in a document.
    public struct Permissions : OptionSet {

        public var rawValue: Int32

        public init(rawValue: Int32) {
            self.rawValue = rawValue
        }

        /// The user can read the document.
        public static let read = Permissions(rawValue: HPDF_ENABLE_READ)

        /// The user can print the document.
        public static let print = Permissions(rawValue: HPDF_ENABLE_PRINT)

        /// The user can edit the contents of the document other than annotations, form fields.
        public static let editAll = Permissions(rawValue: HPDF_ENABLE_EDIT_ALL)

        /// The user can copy the text and the graphics of the document.
        public static let copy = Permissions(rawValue: HPDF_ENABLE_COPY)

        /// The user can add or modify the annotations and form fields of the document.
        public static let edit = Permissions(rawValue: HPDF_ENABLE_EDIT)
    }
}
