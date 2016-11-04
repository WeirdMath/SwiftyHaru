//
//  Grid.LabelParameters.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 04.11.16.
//
//

public extension Grid {
    
    /// Represents the properties of a grid's line labels. Labels can only be placed near serifs.
    public struct LabelParameters {
        
        /// Default parameters, where the `font` is Helvetica, the size of the font is 5,
        /// the color of the labels is 50% gray the frequency is 5 and the offset is 0.
        public static let `default` = LabelParameters()
        
        /// The font of labels.
        public var font: Font
        
        /// The font size of labels.
        public var fontSize: Float
        
        /// The color of labels.
        public var fontColor: Color
        
        /// The nubmber of major lines per one label.
        public var frequency: Int
        
        /// Normally labels are placed in such a way that a major line goes through the center of a label,
        /// and the bounding box of a label touches the bound of the grid, but you can specify an offset.
        public var offset: Vector
        
        /// Creates a new label parameter set.
        ///
        /// - parameter font:       The font of labels. Default is Helvetica.
        /// - parameter fontSize:   The font size of labels. Default value is 5.
        /// - parameter fontColor:  The color of labels. Default is 50% gray.
        /// - parameter frequency:  The nubmber of major lines per one label. Default value is 5.
        /// - parameter offset:     The offset of the label. Default value is `.zero`.
        public init(font: Font = .helvetica,
                    fontSize: Float = 5,
                    fontColor: Color = Color(gray: 0.5)!,
                    frequency: Int = 5,
                    offset: Vector = .zero) {
            
            self.font = font
            self.fontSize = fontSize
            self.fontColor = fontColor
            self.frequency = frequency
            self.offset = offset
        }
    }
}

extension Grid.LabelParameters: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Grid.LabelParameters, rhs: Grid.LabelParameters) -> Bool {
        return lhs.font == rhs.font &&
            lhs.fontColor == rhs.fontColor &&
            lhs.fontSize == rhs.fontSize &&
            lhs.frequency == rhs.frequency &&
            lhs.offset == rhs.offset
    }
}
