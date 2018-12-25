//
//  Grid.Serifs.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 04.11.16.
//
//

extension Grid {
    
    /// Encapsulates the parameters of the top, bottom, left and right serifs of the grid.
    public struct Serifs: Hashable {
        
        /// Default set, where all the serif parameters are set to their `.default`.
        public static let `default` = Serifs()
        
        /// The serifs for vertical lines at the top of the grid.
        public var top: SerifParameters?
        
        /// The serifs for vertical lines at the bottom of the grid.
        public var bottom: SerifParameters?
        
        /// The serifs for horizontal lines on the left of the grid.
        public var left: SerifParameters?
        
        /// The serifs for horizontal lines on the right of the grid.
        public var right: SerifParameters?
        
        /// Creates a new set of the serif parameters for each kind of serifs.
        ///
        /// Each parameter's default value is `SerifParameters.default`.
        ///
        /// - parameter top:     The parameters of the serifs for vertical
        ///                      lines at the top of the grid. If specified `nil`, no such serifs
        ///                      will be drawn.
        /// - parameter bottom:  The parameters of the serifs for vertical
        ///                      lines at the bottom of the grid. If specified `nil`, no such serifs
        ///                      will be drawn.
        /// - parameter left:    The parameters of the serifs for horizontal
        ///                      lines on the left of the grid. If specified `nil`, no such serifs
        ///                      will be drawn.
        /// - parameter right:   The parameters of the serifs for horizontal
        ///                      lines on the right of the grid. If specified `nil`, no such serifs
        ///                      will be drawn.
        public init(top: SerifParameters? = .default,
                    bottom: SerifParameters? = .default,
                    left: SerifParameters? = .default,
                    right: SerifParameters? = .default) {
            
            self.top = top
            self.bottom = bottom
            self.left = left
            self.right = right
        }
    }
}
