//
//  Observable.swift
//  DJBExtensionKit
//
//  Created by Douwe Bos on 18/2/21.
//

import RxSwift

extension Observable {
    public func delayEach(_ dueTime: RxSwift.RxTimeInterval, scheduler: RxSwift.SchedulerType) -> RxSwift.Observable<Element> {
        return self.concatMap { Observable.just($0).delay(dueTime, scheduler: scheduler) }
    }

    public func delayEachIf(_ dueTime: RxSwift.RxTimeInterval, scheduler: RxSwift.SchedulerType, comparer: @escaping ((Element) -> Bool)) -> RxSwift.Observable<Element> {
        return self.concatMap { value -> RxSwift.Observable<Element> in
            if comparer(value) {
                return Observable.just(value).delay(dueTime, scheduler: scheduler)
            } else {
                return Observable.just(value)
            }
        }
    }
}
