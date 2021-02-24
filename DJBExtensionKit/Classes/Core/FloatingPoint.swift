//
//  FloatingPoint.swift
//  DJBExtensionKit
//
//  Created by Douwe Bos on 23/2/21.
//

import Foundation

public extension FloatingPoint {
    var radians: Self {
        get {
            return self * .pi / Self(180)
        }
    }
}
