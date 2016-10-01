//
//  Unimplemented.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 01.10.16.
//
//

internal func Unimplemented(_ function: String = #function, file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError("\(function) is not yet implemented", file: file, line: line)
}
