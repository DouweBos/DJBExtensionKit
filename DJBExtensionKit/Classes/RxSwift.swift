//
//  RxSwift.swift
//  DJBExtentionKit
//
//  Created by Douwe Bos on 14/08/2019.
//  Copyright © 2019 DJBSoftware. All rights reserved.
//

#if DJB_EXT_OFFER_RXSWIFT
import RxSwift

public extension ObservableType {
    func currentAndPrevious() -> Observable<(current: Self.E, previous: Self.E?)> {
        return self.multicast({ () -> PublishSubject<Self.E> in PublishSubject<Self.E>() }) { (values: Observable<Self.E>) -> Observable<(current: Self.E, previous: Self.E?)> in
            let pastValues = values.asObservable().map { previous -> Self.E? in previous }.startWith(nil)
            return Observable.zip(values.asObservable(), pastValues) { (current, previous) in
                return (current: current, previous: previous)
            }
        }
    }
}
#endif
