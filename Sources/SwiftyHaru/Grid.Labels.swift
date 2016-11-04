//
//  Grid.Labels.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 04.11.16.
//
//

public extension Grid {
    
    /// Encapsulates the parameters of the labels for vertical and horizontal lines.
    public struct Labels {
        
        /// Default set, where all the label parameters are set to their `.default`.
        public static let `default` = Labels()
        
        /// The labels for vertical lines at the top of the grid.
        public var top: LabelParameters?
        
        /// The labels for vertical lines at the bottom of the grid.
        public var bottom: LabelParameters?
        
        /// The labels for horizontal lines on the left of the grid.
        public var left: LabelParameters?
        
        /// The labels for horizontal lines on the right of the grid.
        public var right: LabelParameters?
        
        /// Creates a new set of the label parameters for each kind of labels.
        ///
        /// Each parameter's default value is `LabelParameters.default`.
        ///
        /// - parameter top:     The parameters of the labels for vertical
        ///                      lines at the top of the grid. If specified `nil`, no such labels
        ///                      will be drawn.
        /// - parameter bottom:  The parameters of the labels for vertical
        ///                      lines at the bottom of the grid. If specified `nil`, no such labels
        ///                      will be drawn.
        /// - parameter left:    The parameters of the labels for horizontal
        ///                      lines on the left of the grid. If specified `nil`, no such labels
        ///                      will be drawn.
        /// - parameter right:   The parameters of the labels for horizontal
        ///                      lines on the right of the grid. If specified `nil`, no such labels
        ///                      will be drawn.
        public init(top: LabelParameters? = .default,
                    bottom: LabelParameters? = .default,
                    left: LabelParameters? = .default,
                    right: LabelParameters? = .default) {
            
            self.top = top
            self.bottom = bottom
            self.left = left
            self.right = right
        }
    }
}

extension Grid.Labels: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Grid.Labels, rhs: Grid.Labels) -> Bool {
        return lhs.left == rhs.left &&
            lhs.right == rhs.right &&
            lhs.top == rhs.top &&
            lhs.bottom == rhs.bottom
    }
}
