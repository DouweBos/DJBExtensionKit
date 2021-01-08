//
//  UIColor.swift
//  DJBExtentionKit
//
//  Created by Douwe Bos on 14/08/2019.
//  Copyright © 2019 DJBSoftware. All rights reserved.
//

import UIKit

public extension UIColor {
    
    
    /// Convenience init to initialize an UIColor object without all those `/255.0`
    ///
    /// - Parameters:
    ///   - redByte: 0-255 value for red
    ///   - greenByte: 0-255 value for green
    ///   - blueByte: 0-255 value for blue
    ///   - alpha: 0.0-1.0 value for alpha
    convenience init(red: Int = 0, green: Int = 0, blue: Int = 0, opacity: CGFloat = 1.0) {
        precondition(0...255 ~= red   &&
            0...255 ~= green &&
            0...255 ~= blue  &&
            0...255 ~= opacity, "input range is out of range 0...255")
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: opacity)
    }
}
