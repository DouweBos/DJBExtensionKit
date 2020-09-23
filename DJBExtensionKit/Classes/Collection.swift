//
//  Collection.swift
//  DJBExtentionKit
//
//  Created by Douwe Bos on 14/08/2019.
//  Copyright © 2019 DJBSoftware. All rights reserved.
//

import Foundation

public extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        return index >= startIndex && index < endIndex
            ? self[index]
            : nil
    }
    
    func choose(_ n: Int) -> ArraySlice<Element> {
        shuffled().prefix(n)
    }
}

public extension Dictionary {

    subscript <T> (keyPath keyPath: String) -> T? {
        get {
            return valueForKeyPath(keyPath)
        }
    }
    
    /// - Description
    ///   - The function will return a value on given keypath
    ///   - if Dictionary is ["team": ["name": "KNR"]]  the to fetch team name pass keypath: team.name
    ///   - If you will pass "team" in keypath it will return  team object
    /// - Parameter keyPath: keys joined using '.'  such as "key1.key2.key3"
    func valueForKeyPath <T> (_ keyPath: String) -> T? {
        let array = keyPath.components(separatedBy: ".")
        return value(array, self) as? T

    }

    /// - Description:"
    ///   - The function will return a value on given keypath. It keep calling recursively until reach to the keypath. Here are few sample:
    ///   - if Dictionary is ["team": ["name": "KNR"]]  the to fetch team name pass keypath: team.name
    ///   - If you will pass "team" in keypath it will return  team object
    /// - Parameters:
    ///   - keys: array of keys in a keypath
    ///   - dictionary: The dictionary in which value need to find
    private func value(_ keys: [String], _ dictionary: Any?) -> Any? {
        guard let dictionary = dictionary as? [String: Any],  !keys.isEmpty else {
            return nil
        }
        if keys.count == 1 {
            return dictionary[keys[0]]
        }
        return value(Array(keys.suffix(keys.count - 1)), dictionary[keys[0]])
    }
}
