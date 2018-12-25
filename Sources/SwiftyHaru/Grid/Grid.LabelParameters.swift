//
//  Grid.LabelParameters.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 04.11.16.
//
//

extension Grid {
    
    /// Represents the properties of a grid's line labels. Labels can only be placed near serifs.
    public struct LabelParameters {
        
        /// The sequnce of the text labels to draw.
        public var sequence: AnySequence<String>
        
        /// The font of labels.
        public var font: Font
        
        /// The font size of labels.
        public var fontSize: Float
        
        /// The color of labels.
        public var fontColor: Color
        
        /// The nubmber of major lines per one label. Must be positive.
        public var frequency: Int
        
        /// Normally labels are placed in such a way that a major line goes through the center of a label,
        /// and the bounding box of a label touches the bound of the grid, but you can specify an offset.
        public var offset: Vector
        
        /// Normally the sequence of labels is drawn from left to right (bottom to top).
        /// Setting this property to `true` causes the sequence to be drawn from right to left (top to bottom).
        public var reversed: Bool
        
        /// Creates a new label parameter set.
        ///
        /// - parameter sequence:   The sequnce of the text labels to draw.
        /// - parameter font:       The font of labels. Default is Helvetica.
        /// - parameter fontSize:   The font size of labels. Default value is 5.
        /// - parameter fontColor:  The color of labels. Default is 50% gray.
        /// - parameter frequency:  The nubmber of major lines per one label. Default value is 5. Must be positive.
        /// - parameter offset:     The offset of the label. Default value is `.zero`.
        /// - parameter reversed:   The order in which to draw the labels. Default is `false`.
        public init<S : Sequence>(sequence: S,
                                  font: Font = .helvetica,
                                  fontSize: Float = 5,
                                  fontColor: Color = Color(gray: 0.5)!,
                                  frequency: Int = 5,
                                  offset: Vector = .zero,
                                  reversed: Bool = false) where S.Element == String {

            self.sequence = AnySequence(sequence)
            self.font = font
            self.fontSize = fontSize
            self.fontColor = fontColor
            self.frequency = frequency > 0 ? frequency : 5
            self.offset = offset
            self.reversed = reversed
        }
    }
}

extension Grid.LabelParameters: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Complexity: O(N), where N is the number of elements of a shorter label sequence.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Grid.LabelParameters, rhs: Grid.LabelParameters) -> Bool {
        
        return lhs.font == rhs.font &&
            lhs.fontColor == rhs.fontColor &&
            lhs.fontSize == rhs.fontSize &&
            lhs.frequency == rhs.frequency &&
            lhs.offset == rhs.offset &&
            lhs.reversed == rhs.reversed
    }
}
