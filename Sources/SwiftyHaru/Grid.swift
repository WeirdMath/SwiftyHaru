//
//  Grid.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 03.11.16.
//
//

import DefaultStringConvertible

/// Represents a grid that can be drawn on a PDF page.
public struct Grid {
    
    /// Creates a new grid.
    ///
    /// - parameter size:   The size of the grid.
    /// - parameter lines:  The parameters of the vertical and horizontal major and minor lines of the grid.
    ///                     Default value is `Lines.default`.
    /// - parameter labels: The parameters of the labels for vertocal and horizontal lines of the grid. If
    ///                     specified `nil`, no labels will be drawn. Default value is `nil`.
    /// - parameter serifs: The parameters of the serifs for vertocal and horizontal lines of the grid. If
    ///                     specified `nil`, no serifs will be drawn. Default value is `Serifs.defalut`.
    public init(size: Size, lines: Lines = .default, labels: Labels? = nil, serifs: Serifs? = .default) {
        
        self.size = size
        self.lines = lines
        
        if let labels = labels {
            self.labels = labels
        } else {
            self.labels = Labels(top: nil, bottom: nil, left: nil, right: nil)
        }
        
        if let serifs = serifs {
            self.serifs = serifs
        } else {
            self.serifs = Serifs(top: nil, bottom: nil, left: nil, right: nil)
        }
    }
    
    /// Creates a new grid.
    ///
    /// - parameter width:  The width of the grid.
    /// - parameter height: The height of the grid.
    /// - parameter lines:  The parameters of the vertical and horizontal major and minor lines of the grid.
    ///                     Default value is `Lines.default`.
    /// - parameter labels: The parameters of the labels for vertocal and horizontal lines of the grid. If
    ///                     specified `nil`, no labels will be drawn. Default value is `nil`.
    /// - parameter serifs: The parameters of the serifs for vertocal and horizontal lines of the grid. If
    ///                     specified `nil`, no serifs will be drawn. Default value is `Serifs.defalut`.
    public init(width: Float,
                height: Float,
                lines: Lines = .default,
                labels: Labels? = nil,
                serifs: Serifs? = .default) {
        
        self.init(size: Size(width: width, height: height), lines: lines, labels: labels, serifs: serifs)
    }
    
    // MARK: - Grid parameters
    
    /// The size of the grid.
    public var size: Size
    
    /// The parameters of the lines of the grid.
    public var lines: Lines
    
    /// The parameters of the labels of the grid.
    public var labels: Labels
    
    /// The parameters of the serifs of the grid.
    public var serifs: Serifs
    
}

extension Grid: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Grid, rhs: Grid) -> Bool {
        return lhs.size == rhs.size &&
            lhs.lines == rhs.lines &&
            lhs.labels == rhs.labels &&
            lhs.serifs == rhs.serifs
    }
}

extension Grid: CustomStringConvertible {}
