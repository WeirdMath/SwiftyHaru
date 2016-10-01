//
//  _HaruBridgeable.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 30.09.16.
//
//

internal protocol _HaruBridgeable {
    
    associatedtype HaruType
    
    var _haruObject: HaruType { get }
}
