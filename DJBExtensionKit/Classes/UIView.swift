//
//  UIView.swift
//  DJBExtentionKit
//
//  Created by Douwe Bos on 14/08/2019.
//  Copyright © 2019 DJBSoftware. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func circularView(with bag: DisposeBag) {
        cornerRadius = bounds.height / 2.0
        
        self.rx.observeWeakly(CGRect.self, #keyPath(UIImageView.bounds))
            .compactMap { $0 }
            .subscribe(
                onNext: { [weak self] newBounds in
                    self?.cornerRadius = newBounds.height / 2.0
                }
            )
            .disposed(by: bag)
    }
}

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
