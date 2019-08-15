//
//  RxSwift.swift
//  DJBExtentionKit
//
//  Created by Douwe Bos on 14/08/2019.
//  Copyright © 2019 DJBSoftware. All rights reserved.
//

#if canImport(RxSwift)
import RxSwift

public extension ObservableType {
    func currentAndPrevious() -> Observable<(current: E, previous: E?)> {
        return self.multicast({ () -> PublishSubject<E> in PublishSubject<E>() }) { (values: Observable<E>) -> Observable<(current: E, previous: E?)> in
            let pastValues = values.asObservable().map { previous -> E? in previous }.startWith(nil)
            return Observable.zip(values.asObservable(), pastValues) { (current, previous) in
                return (current: current, previous: previous)
            }
        }
    }
}
#endif
