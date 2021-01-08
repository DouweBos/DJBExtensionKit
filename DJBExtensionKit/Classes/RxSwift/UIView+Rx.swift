//
//  UIView+Rx.swift
//  DJBExtensionKit
//
//  Created by Douwe Bos on 8/1/21.
//

import Foundation
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
