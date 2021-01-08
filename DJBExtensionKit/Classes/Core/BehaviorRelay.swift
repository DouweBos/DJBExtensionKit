//
//  BehaviorRelay.swift
//  DJBExtensionKit
//
//  Created by Douwe Bos on 29/6/20.
//

import RxCocoa

extension BehaviorRelay {
    public func refresh() {
        accept(value)
    }
}

/// Wrap the functions I want to use from the Array struct in a protocol.
/// This exposes them if I want to extend something else where Element: Array
/// Since extension where Element == Array is not allowed without specifying the Array's Element
public protocol SecretlyJustAnArray {
    associatedtype Element
    
    @inlinable mutating func append<S>(contentsOf newElements: __owned S)  where S : Sequence, Self.Element == S.Element
    @inlinable mutating func append(_ newElement: __owned Element)
    @inlinable mutating func insert(_ newElement: __owned Element, at i: Int)
    @inlinable mutating func remove(at position: Int) -> Element
}


// MARK: - SecretlyJustAnArray
extension Array: SecretlyJustAnArray {}


// MARK: - Element: SecretlyJustAnArray
extension BehaviorRelay where Element: SecretlyJustAnArray {
    
    /// Clear stored value with an empty sequence
    public func reset() {
        accept([] as! Element)
    }
    
    
    /// Append a given sequence's elements to stored value's sequence
    ///
    /// - Parameter newValues: Sequence values to append
    public func append(newValues: Array<Element.Element>) {
        var new = value
        new.append(contentsOf: newValues)
        accept(new)
    }
    
    
    /// Append a given element to the stored value's sequence
    ///
    /// - Parameter newValue: Element to append
    public func append(newValue: Element.Element) {
        var new = value
        new.append(newValue)
        accept(new)
    }
    
    
    /// Insert an element into the sequence at the given index
    ///
    /// - Parameters:
    ///   - newValue: New element to insert
    ///   - index: Index to insert it at
    public func insert(_ newValue: Element.Element, at index: Int) {
        var new = value
        new.insert(newValue, at: index)
        accept(new)
    }
    
    
    /// Remove a value at the given index
    ///
    /// - Parameter at: Index whose value to remove
    public func remove(at: Int) {
        var new = value
        let _ = new.remove(at: at)
        accept(new)
    }
}

// Extending something with a Dictionary as Element can not be done without specifying the data types for the keys and values
// This is a hacky way to make it possible
public protocol SecretlyJustADictionary {
    associatedtype Key
    associatedtype Value
    
    @discardableResult @inlinable mutating func updateValue(_ value: __owned Value, forKey key: Key) -> Value?
}


// MARK: - SecretlyJustADictionary
extension Dictionary: SecretlyJustADictionary {}


// MARK: - Elemt: SecretlyJustADictionary
extension BehaviorRelay where Element: SecretlyJustADictionary {
    
    /// Clear stored value with an empty dictionary
    public func reset() {
        accept([:] as! Element)
    }
    

    /// Set a new value for the given index
    ///
    /// - Parameters:
    ///   - newValue: New value which should be set in the stored value
    ///   - index: The index at which the value should be stored
    public func set(newValue: Element.Value, for index: Element.Key) {
        var new = value
        new.updateValue(newValue, forKey: index)
        accept(new)
    }
}
