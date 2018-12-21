//
//  Sequence.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 05/11/2016.
//
//

/// Concatenates the sequences.
///
/// - parameter lhs: The base sequence.
/// - parameter rhs: The sequence to concatenate to the base sequence.
///
/// - returns: A new sequence constructed by concatenating the two sequences.
internal func +<LHS: Sequence, RHS: Sequence>(lhs: LHS, rhs: RHS) -> AnySequence<LHS.Element>
    where LHS.Element == RHS.Element {

        var lhsIterator = lhs.makeIterator()
        var rhsIterator = rhs.makeIterator()

        return AnySequence {
            return AnyIterator {
                lhsIterator.next() ?? rhsIterator.next()
            }
        }
}

extension Sequence {
    
    /// Appends the new element to the beginning of the sequence.
    ///
    /// - parameter lhs: The element to append.
    /// - parameter rhs: The base sequence.
    ///
    /// - returns: A new sequence constructed by appending the new element to the beginning of the base sequence.
    internal static func + (lhs: Element, rhs: Self) -> AnySequence<Element> {
        return CollectionOfOne(lhs) + rhs
    }
    
    /// Appends the new element to the end of the sequence.
    ///
    /// - parameter lhs: The base sequence.
    /// - parameter rhs: The element to append.
    ///
    /// - returns: A new sequence constructed by appending the new element to the end of the base sequence.
    internal static func + (lhs: Self, rhs: Element) -> AnySequence<Element> {
        return lhs + CollectionOfOne(rhs)
    }
}
