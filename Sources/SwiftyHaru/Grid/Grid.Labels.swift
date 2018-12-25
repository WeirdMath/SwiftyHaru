//
//  Grid.Labels.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 04.11.16.
//
//

extension Grid {
    
    /// Encapsulates the parameters of the labels for vertical and horizontal lines.
    public struct Labels: Equatable {

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
