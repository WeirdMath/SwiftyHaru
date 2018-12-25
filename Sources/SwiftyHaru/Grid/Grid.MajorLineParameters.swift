//
//  Grid.MajorLineParameters.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 04.11.16.
//
//

extension Grid {
    
    /// Represents the properties of a grid's major lines.
    public struct MajorLineParameters: Hashable {
        
        /// Default parameters, where line width is 0.5, line spacing is 10, line color is 80% gray.
        public static let `default` = MajorLineParameters()
        
        /// The width of lines.
        public var lineWidth: Float
        
        /// The spacing between lines. Must be positive.
        public var lineSpacing: Float
        
        /// The color of lines.
        public var lineColor: Color
        
        /// Creates a new line parameter set.
        ///
        /// - parameter lineWidth:   The width of a line. Default value is 0.5.
        /// - parameter lineSpacing: The spacing between lines. Must be positive. Default value is 10.
        /// - parameter lineColor:   The color of lines. Default is 80% gray.
        public init(lineWidth: Float = 0.5, lineSpacing: Float = 10, lineColor: Color = Color(gray: 0.8)!) {
            self.lineWidth = lineWidth
            self.lineSpacing = lineSpacing > 0 ? lineSpacing : 10
            self.lineColor = lineColor
        }
    }
}
