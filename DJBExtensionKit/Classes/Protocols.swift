//
//  Protocols.swift
//  DJBExtensionKit
//
//  Created by Douwe Bos on 10/12/2019.
//

import Foundation

public protocol HasReuseIdentifier {
    static var reuseIdentifier: String { get }
}

public protocol HasUINib {
    static var nib: UINib { get }
}

public protocol Constrained {}

public protocol ConstrainedStylable {
    func styling()
}

public protocol ConstrainedChildren {
    func children()
}

public extension Constrained where Self: UIView {
    @discardableResult
    @inline(__always)
    static func constrained(
        initializer: (() -> Self)? = nil,
        _ block: (Self) throws -> Void
    ) rethrows -> Self {
        let instance = initializer?() ?? Self.init()
        instance.translatesAutoresizingMaskIntoConstraints = false
        try block(instance)
        return instance
    }
    
    @discardableResult
    @inline(__always)
    static func constrainedWith(
        initializer: (() -> Self)? = nil,
        parent parentView: UIView,
        constraints: ((Self) throws -> Void)? = nil
    ) rethrows -> Self {
        return try Self.constrained(initializer: initializer) { instance in
            if let stylable = instance as? ConstrainedStylable {
                stylable.styling()
            }
            
            if let parentStackview = parentView as? UIStackView {
                parentStackview.addArrangedSubview(instance)
            } else {
                parentView.addSubview(instance)
            }
            
            try constraints?(instance)
            
            if let children = instance as? ConstrainedChildren {
                children.children()
            }
        }
    }
}

extension UIView: Constrained {}
extension UIStackView {
    @discardableResult
    @inline(__always)
    public static func constrained(arrangedSubviews: [UIView], _ block: (UIStackView) throws -> Void) rethrows -> UIStackView {
        let instance = UIStackView(arrangedSubviews: arrangedSubviews)
        instance.translatesAutoresizingMaskIntoConstraints = false
        try block(instance)
        return instance
    }
}
extension UIImageView {
    @discardableResult
    @inline(__always)
    public static func constrained(image: UIImage?, _ block: (UIImageView) throws -> Void) rethrows -> UIImageView {
        let instance = UIImageView(image: image)
        instance.translatesAutoresizingMaskIntoConstraints = false
        try block(instance)
        return instance
    }
}
