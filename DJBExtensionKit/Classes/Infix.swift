//
//  Infix.swift
//  DJBExtensionKit
//
//  Created by Douwe Bos on 04/10/2019.
//

import Foundation

infix operator ~>
func ~><T, U>(value: T, next: ((T) -> U)) -> U {
    return next(value)
}
