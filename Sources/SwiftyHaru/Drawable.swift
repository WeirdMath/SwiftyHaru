//
//  Drawable.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 03.11.16.
//
//

/// Conforming types represent some high-level entities that can be put onto a page, like tables, grids etc.
/// They must implement the `draw(in:)` method that does lower level things.
public protocol Drawable {
    /// This method must perform drawing operations in the provided `context`. Use it to visualize your entity.
    ///
    /// - parameter context: The context to perform drawing in.
    func draw(in context: DrawingContext, position: Point)
}
