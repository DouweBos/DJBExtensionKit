//
//  UISearchBar.swift
//  DJBExtentionKit
//
//  Created by Douwe Bos on 14/08/2019.
//  Copyright © 2019 DJBSoftware. All rights reserved.
//

import UIKit

public extension UISearchBar {
    func changeSearchBarColor(fieldColor: UIColor, backColor: UIColor, borderColor: UIColor?) {
        UIGraphicsBeginImageContext(bounds.size)
        backColor.setFill()
        UIBezierPath(rect: bounds).fill()
        setBackgroundImage(UIGraphicsGetImageFromCurrentImageContext()!, for: UIBarPosition.any, barMetrics: .default)
        
        let newBounds = bounds.insetBy(dx: 0, dy: 8)
        fieldColor.setFill()
        let path = UIBezierPath(roundedRect: newBounds, cornerRadius: newBounds.height / 2)
        
        if let borderColor = borderColor {
            borderColor.setStroke()
            path.lineWidth = 1 / UIScreen.main.scale
            path.stroke()
        }
        
        path.fill()
        setSearchFieldBackgroundImage(UIGraphicsGetImageFromCurrentImageContext()!, for: UIControl.State.normal)
        
        UIGraphicsEndImageContext()
    }
}
