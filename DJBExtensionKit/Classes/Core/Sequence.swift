//
//  Sequence.swift
//  DJBExtensionKit
//
//  Created by Douwe Bos on 25/04/2022.
//

import Foundation

public extension Sequence {
    func sorted<T: Comparable>(by path: KeyPath<Element, T>) -> [Self.Element] {
        return sorted { (lhs, rhs) -> Bool in
            return lhs[keyPath: path] < rhs[keyPath: path]
        }
    }
    
    func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        return map { $0[keyPath: keyPath] }
    }
}
