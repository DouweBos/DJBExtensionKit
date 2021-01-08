//
//  UIView.swift
//  DJBExtentionKit
//
//  Created by Douwe Bos on 14/08/2019.
//  Copyright © 2019 DJBSoftware. All rights reserved.
//

import UIKit

public extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}

public extension UIView {
    func rotate(clockWise: Bool = true, duration: CFTimeInterval = 1.0) {
        self.layer.removeAnimation(forKey: "rotationAnimation")
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2 * (clockWise ? 1 : -1))
        rotation.duration = duration
        rotation.isCumulative = true
        rotation.repeatCount = 0
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}

public extension UIView {
    // there can be other views between `subview` and `self`
    func getConvertedFrame(fromSubview subview: UIView) -> CGRect? {
        // check if `subview` is a subview of self
        guard subview.isDescendant(of: self) else {
            return nil
        }
        
        var frame = subview.frame
        if subview.superview == nil {
            return frame
        }
        
        var superview = subview.superview
        while superview != self {
            frame = superview!.convert(frame, to: superview!.superview)
            if superview!.superview == nil {
                break
            } else {
                superview = superview!.superview
            }
        }
        
        return superview!.convert(frame, to: self)
    }
}

public extension UIView {
    func rootLayoutIfNeeded() {
        if let superV = superview {
            superV.rootLayoutIfNeeded()
        } else {
            self.layoutIfNeeded()
        }
    }
}
