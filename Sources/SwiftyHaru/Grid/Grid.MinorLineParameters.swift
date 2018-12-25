//
//  Grid.MinorLineParameters.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 04.11.16.
//
//

extension Grid {
    
    /// Represents the properties of a grid's minor lines.
    public struct MinorLineParameters: Hashable {
        
        /// Default parameters, where line width is 0.25, line color is 80% gray and the default
        /// number of minor segments per one major segment is 2.
        public static let `default` = MinorLineParameters()
        
        /// The width of lines.
        public var lineWidth: Float
        
        /// The number of minor segments per one vertical major segment.
        /// Setting this property to N means that N-1 minor lines will be drawn between
        /// two adjacent major lines. Must be positive.
        public var minorSegmentsPerMajorSegment: Int
        
        /// The color of lines.
        public var lineColor: Color
        
        /// Creates a new line parameter set.
        ///
        /// - parameter lineWidth:                    The width of a line. Default value is 0.25
        /// - parameter minorSegmentsPerMajorSegment: The number of minor segments per one vertical major segment.
        ///                                           Must be positive.
        ///                                           Defaulr value is 2.
        /// - parameter lineColor:                    The color of lines. Default is 80% gray.
        public init(lineWidth: Float = 0.25,
                    minorSegmentsPerMajorSegment: Int = 2,
                    lineColor: Color = Color(gray: 0.8)!) {
            self.lineWidth = lineWidth
            self.minorSegmentsPerMajorSegment = minorSegmentsPerMajorSegment > 0 ? minorSegmentsPerMajorSegment : 2
            self.lineColor = lineColor
        }
    }
}
