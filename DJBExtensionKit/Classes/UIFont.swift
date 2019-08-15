//
//  UIFont.swift
//  DJBExtentionKit
//
//  Created by Douwe Bos on 14/08/2019.
//  Copyright © 2019 DJBSoftware. All rights reserved.
//

import UIKit

public extension UIFont {
    
    
    /// Return a medium font version for the given font family of the given size.
    ///
    /// - Parameters:
    ///   - family: Font family
    ///   - size: Font size
    /// - Returns: Font
    static func mediumFont(of family: String, for size: CGFloat) -> UIFont? {
        return UIFont(name: "\(family)-Medium", size: size)
    }
    
    /// Return a bold font version for the given font family of the given size.
    ///
    /// - Parameters:
    ///   - family: Font family
    ///   - size: Font size
    /// - Returns: Font
    static func boldFont(of family: String, for size: CGFloat) -> UIFont? {
        return UIFont(name: "\(family)-Bold", size: size)
    }
    
    /// Return an extra bold font version for the given font family of the given size.
    ///
    /// - Parameters:
    ///   - family: Font family
    ///   - size: Font size
    /// - Returns: Font
    static func extraBoldFont(of family: String, for size: CGFloat) -> UIFont? {
        return UIFont(name: "\(family)-Extrabld", size: size)
    }
}
