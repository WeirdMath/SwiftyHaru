//
//  Numeric.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 01.10.16.
//
//

public protocol Numeric: Comparable {
    static func +(lhs: Self, rhs: Self) -> Self
}

extension Int: Numeric {}

extension Int8: Numeric {}

extension Int16: Numeric {}

extension Int32: Numeric {}

extension Int64: Numeric {}

extension UInt: Numeric {}

extension UInt8: Numeric {}

extension UInt16: Numeric {}

extension UInt32: Numeric {}

extension UInt64: Numeric {}

extension Float: Numeric {}

extension Double: Numeric {}
