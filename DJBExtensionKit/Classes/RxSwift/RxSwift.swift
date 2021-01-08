//
//  RxSwift.swift
//  DJBExtentionKit
//
//  Created by Douwe Bos on 14/08/2019.
//  Copyright © 2019 DJBSoftware. All rights reserved.
//

import RxSwift
import RxCocoa

public extension ObservableType {
    func currentAndPrevious() -> Observable<(current: Element, previous: Element?)> {
        return self.multicast({ () -> PublishSubject<Element> in PublishSubject<Element>() }) { (values: Observable<Element>) -> Observable<(current: Element, previous: Element?)> in
            let pastValues = values.asObservable().map { previous -> Element? in previous }.startWith(nil)
            return Observable.zip(values.asObservable(), pastValues) { (current, previous) in
                return (current: current, previous: previous)
            }
        }
    }
}

extension Reactive where Base: UILabel {

    /// Bindable sink for `text` property.
    public var textForceLayout: Binder<String?> {
        return Binder(self.base) { label, text in
            label.text = text
            
            label.setNeedsLayout()
            label.layoutIfNeeded()
        }
    }
}
