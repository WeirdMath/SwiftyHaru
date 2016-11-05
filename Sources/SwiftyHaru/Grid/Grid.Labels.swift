//
//  Grid.Labels.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 04.11.16.
//
//

import DefaultStringConvertible

public extension Grid {
    
    /// Encapsulates the parameters of the labels for vertical and horizontal lines.
    public struct Labels {

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
        /// - parameter top:     The parameters of the labels for vertical
        ///                      lines at the top of the grid. If specified `nil`, no such labels
        ///                      will be drawn. Default value is `nil`.
        /// - parameter bottom:  The parameters of the labels for vertical
        ///                      lines at the bottom of the grid. If specified `nil`, no such labels
        ///                      will be drawn. Default value is `nil`.
        /// - parameter left:    The parameters of the labels for horizontal
        ///                      lines on the left of the grid. If specified `nil`, no such labels
        ///                      will be drawn. Default value is `nil`.
        /// - parameter right:   The parameters of the labels for horizontal
        ///                      lines on the right of the grid. If specified `nil`, no such labels
        ///                      will be drawn. Default value is `nil`.
        public init(top: LabelParameters? = nil,
                    bottom: LabelParameters? = nil,
                    left: LabelParameters? = nil,
                    right: LabelParameters? = nil) {
            
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

extension Grid.Labels: CustomStringConvertible {}
