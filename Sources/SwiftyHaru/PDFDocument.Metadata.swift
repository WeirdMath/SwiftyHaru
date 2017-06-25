//
//  PDFDocument.Metadata.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 20/06/2017.
//
//

import Foundation

extension PDFDocument {
    
    public struct Metadata {
        
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

extension PDFDocument.Metadata: Equatable {
    
    public static func == (lhs: PDFDocument.Metadata, rhs: PDFDocument.Metadata) -> Bool {
        
        return
            lhs.author           == rhs.author           &&
            lhs.creator          == rhs.creator          &&
            lhs.title            == rhs.title            &&
            lhs.subject          == rhs.subject          &&
            lhs.keywords         == rhs.keywords         &&
            lhs.timeZone         == rhs.timeZone         &&
            lhs.creationDate     == rhs.creationDate     &&
            lhs.modificationDate == rhs.modificationDate
    }
}
