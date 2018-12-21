//
//  PDFDocument.Metadata.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 20/06/2017.
//
//

import Foundation

extension PDFDocument {
    
    /// This structure encapsulates the metadata of a document.
    public struct Metadata: Equatable {
        
        /// The author of the document.
        public var author: String?
        
        /// The creator of the document.
        public var creator: String?
        
        /// The title of the document.
        public var title: String?
        
        /// The subject of the document.
        public var subject: String?
        
        /// The keywords of the document.
        public var keywords: [String]?
        
        /// The timezone to use for encoding the creation date and the modification date of the document.
        /// Default value is `TimeZone.current`
        public var timeZone: TimeZone = .current
        
        /// The document’s creation date.
        public var creationDate: Date?
        
        /// The document’s last-modified date.
        public var modificationDate: Date?
        
        /// Creates new metadata.
        ///
        /// The default value of each argument is `nil`. `nil` value means that the associated key
        /// will not be added to the document's metadata dictionary.
        ///
        /// - Parameters:
        ///   - author:           The author of the document.
        ///   - creator:          The creator of the document.
        ///   - title:            The title of the document.
        ///   - subject:          The subject of the document.
        ///   - keywords:         The keywords of the document.
        ///   - creationDate:     The document’s creation date.
        ///   - modificationDate: The document’s last-modified date.
        public init(author: String? = nil,
                    creator: String? = nil,
                    title: String? = nil,
                    subject: String? = nil,
                    keywords: [String]? = nil,
                    creationDate: Date? = nil,
                    modificationDate: Date? = nil) {
            
            self.author = author
            self.creator = creator
            self.title = title
            self.subject = subject
            self.keywords = keywords
            self.creationDate = creationDate
            self.modificationDate = modificationDate
        }
    }
}
