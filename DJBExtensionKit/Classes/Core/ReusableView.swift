//
//  ReusableView.swift
//  DJBExtensionKit
//
//  Created by Douwe Bos on 29/9/21.
//

import Foundation
import UIKit
import RxSwift

@objc public protocol ReusableView: AnyObject {
    func prepareForReuse()
}

//public extension Reactive where Base: UIView, Base: ReusableView {
//    public var prepareForReuse: Observable<Void> {
//        return methodInvoked(#selector(ReusableView.prepareForReuse))
//            .map { _ in return }
//    }
//}
