//
//  Protocols.swift
//  DJBExtensionKit
//
//  Created by Douwe Bos on 10/12/2019.
//

import Foundation

public protocol Constrainable {}

public protocol ConstrainableStylable {
    func styling()
}

public protocol ConstrainableChildren {
    func children()
}

public protocol CustomAddChildView {
    func addChild(view: UIView)
}

extension UIStackView: CustomAddChildView {
    public func addChild(view: UIView) {
        addArrangedSubview(view)
    }
}

public extension Constrainable where Self: UIView {
    @discardableResult
    static func instance(
        initializer: (() -> Self)? = nil,
        _ block: (Self) throws -> Void
    ) rethrows -> Self {
        let instance = initializer?() ?? Self.init()
        try block(instance)
        return instance
    }
    
    @discardableResult
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
    static func constrainedWith(
        initializer: (() -> Self)? = nil,
        parent parentView: UIView,
        wrapHeight: Bool = false,
        wrapWidth: Bool = false,
        constraints: ((Self) throws -> Void)? = nil
    ) rethrows -> Self {
        return try Self.constrained(initializer: initializer) { instance in
            if let stylable = instance as? ConstrainableStylable {
                stylable.styling()
            }
            
            if let parentCustom = parentView as? CustomAddChildView {
                parentCustom.addChild(view: instance)
            } else {
                parentView.addSubview(instance)
            }
            
            if wrapHeight {
                instance.setContentHuggingPriority(.defaultHigh, for: .vertical)
            }
            
            if wrapWidth {
                instance.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            }
            
            try constraints?(instance)
            
            if let children = instance as? ConstrainableChildren {
                children.children()
            }
        }
    }
    
    @discardableResult
    static func instanceWith(
        initializer: (() -> Self)? = nil,
        parent parentView: UIView,
        wrapHeight: Bool = false,
        wrapWidth: Bool = false,
        handler: ((Self) throws -> Void)? = nil
    ) rethrows -> Self {
        return try Self.instance(initializer: initializer) { instance in
            if let stylable = instance as? ConstrainableStylable {
                stylable.styling()
            }
            
            if let parentStackview = parentView as? CustomAddChildView {
                parentStackview.addChild(view: instance)
            } else {
                parentView.addSubview(instance)
            }
            
            if wrapHeight {
                instance.setContentHuggingPriority(.defaultHigh, for: .vertical)
            }
            
            if wrapWidth {
                instance.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            }
            
            try handler?(instance)
            
            if let children = instance as? ConstrainableChildren {
                children.children()
            }
        }
    }
    
    @discardableResult
    static func with(
        initializer: (() -> Self)? = nil,
        parent parentView: UIView,
        wrapHeight: Bool = false,
        wrapWidth: Bool = false,
        handler: ((Self) throws -> Void)? = nil
    ) rethrows -> Self {
        return try Self.instance(initializer: initializer) { instance in
            if let stylable = instance as? ConstrainableStylable {
                stylable.styling()
            }
            
            if let parentStackview = parentView as? CustomAddChildView {
                parentStackview.addChild(view: instance)
            } else {
                parentView.addSubview(instance)
            }
            
            if wrapHeight {
                instance.setContentHuggingPriority(.defaultHigh, for: .vertical)
            }
            
            if wrapWidth {
                instance.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            }
            
            try handler?(instance)
            
            if let children = instance as? ConstrainableChildren {
                children.children()
            }
        }
    }
}

extension UIView: Constrainable {}
public extension UIStackView {
    @discardableResult
    static func constrained(arrangedSubviews: [UIView], _ block: (UIStackView) throws -> Void) rethrows -> UIStackView {
        let instance = UIStackView(arrangedSubviews: arrangedSubviews)
        instance.translatesAutoresizingMaskIntoConstraints = false
        try block(instance)
        return instance
    }
}
public extension UIImageView {
    @discardableResult
    static func constrained(image: UIImage?, _ block: (UIImageView) throws -> Void) rethrows -> UIImageView {
        let instance = UIImageView(image: image)
        
        instance.translatesAutoresizingMaskIntoConstraints = false
        try block(instance)
        return instance
    }
}
