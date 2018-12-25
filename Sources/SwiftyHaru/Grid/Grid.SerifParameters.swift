//
//  Grid.SerifParameters.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 04.11.16.
//
//

extension Grid {
    
    /// Represents the properties of a grid's serifs. Serifs are short lines that can be placed on the edges of
    /// a grid and serve to put labels near them.
    public struct SerifParameters: Hashable {
        
        /// Default parameters, where the frequency is 5, the width of the serifs is 0.5
        /// and the color of the serifs is 50% gray.
        public static let `default` = SerifParameters()
        
        /// The nubmber of major lines per one serif. Must be positive.
        public var frequency: Int
        
        /// The thickness of the serifs.
        public var width: Float
        
        /// The length of the serifs.
        public var length: Float
        
        /// The color of the serifs.
        public var color: Color
        
        /// Creates a new serif parameter set.
        ///
        /// - parameter frequency: The nubmber of major lines per one serif. Must be positive. Default value is 5.
        /// - parameter width:     The width of the serifs. Default value is 0.5.
        /// - parameter length:    The length of the serifs. Default value is 5.
        /// - parameter color:     The color of the serifs. Default is 50% gray.
        public init(frequency: Int = 5,
                    width: Float = 0.5,
                    length: Float = 5,
                    color: Color = Color(gray: 0.5)!) {
            
            self.frequency = frequency > 0 ? frequency : 5
            self.width = width
            self.length = length
            self.color = color
        }
    }
}
