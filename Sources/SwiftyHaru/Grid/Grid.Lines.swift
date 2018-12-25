//
//  Grid.Lines.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 04.11.16.
//
//

extension Grid {
    
    /// Encapsulates the parameters of the vertical and horizontal major and minor lines.
    public struct Lines: Hashable {
        
        /// Default set, where all the major and minor line parameters are set to their `.default`.
        public static let `default` = Lines()
        
        /// The parameters of the vertical major lines of the grid.
        public var verticalMajor: MajorLineParameters
        
        /// The parameters of the horizontal major lines of the grid.
        public var horizontalMajor: MajorLineParameters
        
        /// The parameters of the vertical minor lines of the grid.
        public var verticalMinor: MinorLineParameters?
        
        /// The parameters of the horizontal minor lines of the grid.
        public var horizontalMinor: MinorLineParameters?
        
        /// If `true`, draws the horizontal major lines only after the vertical major lines are drawn.
        /// Otherwise draws the horizontal major lines and only then draws vertical major lines.
        ///
        /// - Important: Major lines are always drawn **after** minor lines.
        public var drawVerticalMajorLinesFirst: Bool
        
        /// If `true`, draws the horizontal minor lines only after the vertical minor lines are drawn.
        /// Otherwise draws the horizontal minor lines and only then draws vertical minor lines.
        ///
        /// - Important: Major lines are always drawn **after** minor lines.
        public var drawVerticalMinorLinesFirst: Bool
        
        /// Creates a new set of the line parameters for each type of the line.
        ///
        /// - parameter verticalMajor:               The parameters of the vertical major lines of the grid.
        ///                                          Default line width is 0.5, line spacing is 10,
        ///                                          line color is 80% gray.
        /// - parameter horizontalMajor:             The parameters of the horizontal major lines of the grid.
        ///                                          Default line width is 0.5, line spacing is 10,
        ///                                          line color is 80% gray.
        /// - parameter verticalMinor:               The parameters of the vertical minor lines of the grid.
        ///                                          If specified `nil`, no vertical minor lines will be drawn.
        ///                                          Default line width is 0.25, line color is 80% gray and
        ///                                          the default number of minor segments per one major
        ///                                          segment is 2.
        /// - parameter horizontalMinor:             The parameters of the horizontal minor lines of the grid.
        ///                                          If specified `nil`, no horizontal minor lines will be drawn.
        ///                                          Default line width is 0.25, line color is 80% gray and
        ///                                          the default number of minor segments per one major
        ///                                          segment is 2.
        /// - parameter drawVerticalMajorLinesFirst: If `true`, draws the horizontal major lines only after
        ///                                          the vertical major lines are drawn. Otherwise draws
        ///                                          the horizontal major lines and only then draws vertical
        ///                                          major lines. Default is `false`.
        /// - parameter drawVerticalMinorLinesFirst: If `true`, draws the horizontal minor lines only after
        ///                                          the vertical minor lines are drawn. Otherwise draws
        ///                                          the horizontal minor lines and only then draws vertical
        ///                                          minor lines. Default is `false`.
        public init(verticalMajor: MajorLineParameters = .default,
                    horizontalMajor: MajorLineParameters = .default,
                    verticalMinor: MinorLineParameters? = .default,
                    horizontalMinor: MinorLineParameters? = .default,
                    drawVerticalMajorLinesFirst: Bool = false,
                    drawVerticalMinorLinesFirst: Bool = false) {
            
            self.verticalMajor = verticalMajor
            self.horizontalMajor = horizontalMajor
            self.verticalMinor = verticalMinor
            self.horizontalMinor = horizontalMinor
            self.drawVerticalMajorLinesFirst = drawVerticalMajorLinesFirst
            self.drawVerticalMinorLinesFirst = drawVerticalMinorLinesFirst
        }
    }
}
