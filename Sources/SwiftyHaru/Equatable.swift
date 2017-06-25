//
//  Equatable.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 20/06/2017.
//
//

internal func == <T: Equatable>(lhs: [T]?, rhs: [T]?) -> Bool {
    switch (lhs, rhs) {
    case (.none, .none):
        return true
    case (.some(let lhs), .some(let rhs)):
        return lhs == rhs
    default:
        return false
    }
}
