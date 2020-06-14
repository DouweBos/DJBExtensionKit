//
//  UIImageView.swift
//  DJBExtensionKit
//
//  Created by Douwe Bos on 14/6/20.
//

import UIKit
import RxSwift
import RxCocoa

public extension UIImageView {
    func circularImage(with bag: DisposeBag) {
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
