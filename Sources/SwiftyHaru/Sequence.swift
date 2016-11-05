//
//  Sequence.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 05/11/2016.
//
//

extension Sequence {
    
    /// Concatenates the sequences.
    ///
    /// - parameter lhs: The base sequence.
    /// - parameter rhs: The sequence to concatenate to the base sequence.
    ///
    /// - returns: A new sequence constructed by concatenating the two sequences.
    public static func + (lhs: Self, rhs: Self) -> AnySequence<Iterator.Element> {
        
        var lhsIterator = lhs.makeIterator()
        var rhsIterator = rhs.makeIterator()
        
        return AnySequence {
            return AnyIterator {
                lhsIterator.next() ?? rhsIterator.next()
            }
        }
    }
    
    /// Appends the new element to the beginning of the sequence.
    ///
    /// - parameter lhs: The element to append.
    /// - parameter rhs: The base sequence.
    ///
    /// - returns: A new sequence constructed by appending the new element to the beginning of the base sequence.
    public static func + (lhs: Iterator.Element, rhs: Self) -> AnySequence<Iterator.Element> {
        
        let oneElementSequence = AnySequence([lhs])
        
        let baseSequence = AnySequence<Iterator.Element> { AnyIterator(rhs.makeIterator()) }
        
        return oneElementSequence + baseSequence
    }
    
    /// Appends the new element to the end of the sequence.
    ///
    /// - parameter lhs: The base sequence.
    /// - parameter rhs: The element to append.
    ///
    /// - returns: A new sequence constructed by appending the new element to the end of the base sequence.
    public static func + (lhs: Self, rhs: Iterator.Element) -> AnySequence<Iterator.Element> {
        
        let oneElementSequence = AnySequence([rhs])
        
        let baseSequence = AnySequence<Iterator.Element> { AnyIterator(lhs.makeIterator()) }
        
        return baseSequence + oneElementSequence
    }
}
