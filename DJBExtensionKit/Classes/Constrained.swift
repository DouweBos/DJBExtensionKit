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
    public static func constrained(arrangedSubviews: [UIView], _ block: (UIStackView) throws -> Void) rethrows -> UIStackView {
        let instance = UIStackView(arrangedSubviews: arrangedSubviews)
        instance.translatesAutoresizingMaskIntoConstraints = false
        try block(instance)
        return instance
    }
}
public extension UIImageView {
    @discardableResult
    public static func constrained(image: UIImage?, _ block: (UIImageView) throws -> Void) rethrows -> UIImageView {
        let instance = UIImageView(image: image)
        instance.rx.isHidden
        
        instance.translatesAutoresizingMaskIntoConstraints = false
        try block(instance)
        return instance
    }
}

public struct Constrained<Base> {
    /// Base object to extend.
    public let base: Base

    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: Base) {
        self.base = base
    }
}

/// A type that has reactive extensions.
public protocol ConstrainedCompatible {
    /// Extended type
    associatedtype ConstrainedBase

    /// Reactive extensions.
    static var constrained: Constrained<ConstrainedBase>.Type { get set }

    /// Reactive extensions.
    var constrained: Constrained<ConstrainedBase> { get set }
}

extension ConstrainedCompatible {
    /// Reactive extensions.
    public static var constrained: Constrained<Self>.Type {
        get {
            return Constrained<Self>.self
        }
        // swiftlint:disable:next unused_setter_value
        set {
            // this enables using Reactive to "mutate" base type
        }
    }

    /// Reactive extensions.
    public var constrained: Constrained<Self> {
        get {
            return Constrained(self)
        }
        // swiftlint:disable:next unused_setter_value
        set {
            // this enables using Reactive to "mutate" base object
        }
    }
}

import class Foundation.NSObject

extension NSObject: ConstrainedCompatible { }

extension UIView: ConstrainedCompatible {
    /// Reactive extensions.
    public static var constrained: Constrained<UIView>.Type {
        get {
            return Constrained<UIView>.self
        }
        // swiftlint:disable:next unused_setter_value
        set {
            // this enables using Reactive to "mutate" base type
        }
    }

    /// Reactive extensions.
    public var constrained: Constrained<UIView> {
        get {
            self.translatesAutoresizingMaskIntoConstraints = false
            return Constrained(self)
        }
        // swiftlint:disable:next unused_setter_value
        set {
            // this enables using Reactive to "mutate" base object
        }
    }
}

public enum ConstrainedAnchorRelation {
    case equal
    case greaterThanOrEqualTo
    case lessThanOrEqualTo
}

public enum ConstrainedRatioRelation {
    case widthToHeight
    case heightToWidth
}

// MARK: - Convenience Helper Functions
extension Constrained where Base: UIView {
    public func margin(
        top: CGFloat? = nil,
        bottom: CGFloat? = nil,
        leading: CGFloat? = nil,
        trailing: CGFloat? = nil,
        safeArea: Bool = false
    ) {
        self.base.superview.also { superView in
            top.also { topConstant in
                self.top(
                    to: safeArea ? superView.layoutMarginsGuide.topAnchor : superView.topAnchor,
                    constant: topConstant,
                    priority: nil,
                    isActive: true
                )
            }
            
            bottom.also { bottomConstant in
                self.bottom(
                    to: safeArea ? superView.layoutMarginsGuide.bottomAnchor : superView.bottomAnchor,
                    constant: bottomConstant,
                    priority: nil,
                    isActive: true
                )
            }
            
            leading.also { leadingConstant in
                self.leading(
                    to: safeArea ? superView.layoutMarginsGuide.leadingAnchor : superView.leadingAnchor,
                    constant: leadingConstant,
                    priority: nil,
                    isActive: true
                )
            }
            
            trailing.also { trailingConstant in
                self.trailing(
                    to: safeArea ? superView.layoutMarginsGuide.trailingAnchor : superView.trailingAnchor,
                    constant: trailingConstant,
                    priority: nil,
                    isActive: true
                )
            }
        }
    }
    
    public func center() {
        self.base.superview.also { superView in
            self.center(to: superView)
        }
    }
    
    public func center(to view: UIView) {
        self.centerX(to: view.centerXAnchor)
        self.centerY(to: view.centerYAnchor)
    }
    
    public func centerX() {
        self.base.superview.also { superView in
            self.centerX(to: superView)
        }
    }
    
    public func centerX(to view: UIView) {
        self.centerX(to: view.centerXAnchor)
    }
    
    public func centerY() {
        self.base.superview.also { superView in
            self.centerY(to: superView)
        }
    }
    
    public func centerY(to view: UIView) {
            self.centerY(to: view.centerYAnchor)
    }
    
    public func fill(safeArea: Bool = false) {
        self.margin(top: 0.0, bottom: 0.0, leading: 0.0, trailing: 0.0, safeArea: safeArea)
    }
    
    public func fillVertically(safeArea: Bool = false) {
        self.margin(top: 0.0, bottom: 0.0, leading: nil, trailing: nil, safeArea: safeArea)
    }
    
    public func fillHorizontally(safeArea: Bool = false) {
        self.margin(top: nil, bottom: nil, leading: 0.0, trailing: 0.0, safeArea: safeArea)
    }
    
    public func frame(equals view: UIView) {
        self.center(to: view)
        self.size(equals: view)
    }
    
    public func size(equals view: UIView) {
        self.width(equals: view)
        self.height(equals: view)
    }
}


// MARK: - Top Constraints
extension Constrained where Base: UIView {
    @discardableResult
    public func top(
        to anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>,
        constant: CGFloat = 0.0,
        relation: ConstrainedAnchorRelation = .equal,
        priority: UILayoutPriority? = nil,
        isActive: Bool = true
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint!
        
        switch relation {
        case .equal:
            constraint = self.base.topAnchor.constraint(equalTo: anchor, constant: constant)
        case .greaterThanOrEqualTo:
            constraint = self.base.topAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant)
        case .lessThanOrEqualTo:
            constraint = self.base.topAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant)
        }
        
        priority.also {
            constraint.priority = $0
        }
        
        constraint.isActive = isActive
        
        return constraint
    }
}


// MARK: - Bottom Constraints
extension Constrained where Base: UIView {
    @discardableResult
    public func bottom(
        to anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>,
        constant: CGFloat = 0.0,
        relation: ConstrainedAnchorRelation = .equal,
        priority: UILayoutPriority? = nil,
        isActive: Bool = true
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint!
        
        switch relation {
        case .equal:
            constraint = self.base.bottomAnchor.constraint(equalTo: anchor, constant: constant * -1.0)
        case .greaterThanOrEqualTo:
            constraint = self.base.bottomAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant * -1.0)
        case .lessThanOrEqualTo:
            constraint = self.base.bottomAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant * -1.0)
        }
        
        priority.also {
            constraint.priority = $0
        }
        
        constraint.isActive = isActive
        
        return constraint
    }
}


// MARK: - Leading Constraints
extension Constrained where Base: UIView {
    @discardableResult
    public func leading(
        to anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>,
        constant: CGFloat = 0.0,
        relation: ConstrainedAnchorRelation = .equal,
        priority: UILayoutPriority? = nil,
        isActive: Bool = true
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint!
        
        switch relation {
        case .equal:
            constraint = self.base.leadingAnchor.constraint(equalTo: anchor, constant: constant)
        case .greaterThanOrEqualTo:
            constraint = self.base.leadingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant)
        case .lessThanOrEqualTo:
            constraint = self.base.leadingAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant)
        }
        
        priority.also {
            constraint.priority = $0
        }
        
        constraint.isActive = isActive
        
        return constraint
    }
}


// MARK: - Trailing Constraints
extension Constrained where Base: UIView {
    @discardableResult
    public func trailing(
        to anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>,
        constant: CGFloat = 0.0,
        relation: ConstrainedAnchorRelation = .equal,
        priority: UILayoutPriority? = nil,
        isActive: Bool = true
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint!
        
        switch relation {
        case .equal:
            constraint = self.base.trailingAnchor.constraint(equalTo: anchor, constant: constant * -1.0)
        case .greaterThanOrEqualTo:
            constraint = self.base.trailingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant * -1.0)
        case .lessThanOrEqualTo:
            constraint = self.base.trailingAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant * -1.0)
        }
        
        priority.also {
            constraint.priority = $0
        }
        
        constraint.isActive = isActive
        
        return constraint
    }
}

// MARK: - Center Constraints
extension Constrained where Base: UIView {
    @discardableResult
    public func centerX(
        to anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>,
        constant: CGFloat = 0.0,
        priority: UILayoutPriority? = nil,
        isActive: Bool = true
    ) -> NSLayoutConstraint {
        let constraint = self.base.centerXAnchor.constraint(equalTo: anchor, constant: constant)
        
        priority.also {
            constraint.priority = $0
        }
        
        constraint.isActive = isActive
        
        return constraint
    }
    
    @discardableResult
    public func centerY(
        to anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>,
        constant: CGFloat = 0.0,
        priority: UILayoutPriority? = nil,
        isActive: Bool = true
    ) -> NSLayoutConstraint {
        let constraint = self.base.centerYAnchor.constraint(equalTo: anchor, constant: constant)
        
        priority.also {
            constraint.priority = $0
        }
        
        constraint.isActive = isActive
        
        return constraint
    }
}

// MARK: - Height Constraints
extension Constrained where Base: UIView {
    @discardableResult
    public func height(
        equals view: UIView,
        multiplier: CGFloat = 1.0,
        relation: ConstrainedAnchorRelation = .equal,
        priority: UILayoutPriority? = nil,
        isActive: Bool = true
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint!
        
        switch relation {
        case .equal:
            constraint = self.base.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier)
        case .greaterThanOrEqualTo:
            constraint = self.base.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: multiplier)
        case .lessThanOrEqualTo:
            constraint = self.base.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: multiplier)
        }
        
        priority.also {
            constraint.priority = $0
        }
        
        constraint.isActive = isActive
        
        return constraint
    }
    
    @discardableResult
    public func height(
        equals constant: CGFloat,
        relation: ConstrainedAnchorRelation = .equal,
        priority: UILayoutPriority? = nil,
        isActive: Bool = true
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint!
        
        switch relation {
        case .equal:
            constraint = self.base.heightAnchor.constraint(equalToConstant: constant)
        case .greaterThanOrEqualTo:
            constraint = self.base.heightAnchor.constraint(greaterThanOrEqualToConstant: constant)
        case .lessThanOrEqualTo:
            constraint = self.base.heightAnchor.constraint(lessThanOrEqualToConstant: constant)
        }
        
        priority.also {
            constraint.priority = $0
        }
        
        constraint.isActive = isActive
        
        return constraint
    }
}

// MARK: - Width Constraints
extension Constrained where Base: UIView {
    @discardableResult
    public func width(
        equals view: UIView,
        multiplier: CGFloat = 1.0,
        relation: ConstrainedAnchorRelation = .equal,
        priority: UILayoutPriority? = nil,
        isActive: Bool = true
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint!
        
        switch relation {
        case .equal:
            constraint = self.base.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier)
        case .greaterThanOrEqualTo:
            constraint = self.base.widthAnchor.constraint(greaterThanOrEqualTo: view.widthAnchor, multiplier: multiplier)
        case .lessThanOrEqualTo:
            constraint = self.base.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: multiplier)
        }
        
        priority.also {
            constraint.priority = $0
        }
        
        constraint.isActive = isActive
        
        return constraint
    }
    
    @discardableResult
    public func width(
        equals constant: CGFloat,
        relation: ConstrainedAnchorRelation = .equal,
        priority: UILayoutPriority? = nil,
        isActive: Bool = true
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint!
        
        switch relation {
        case .equal:
            constraint = self.base.widthAnchor.constraint(equalToConstant: constant)
        case .greaterThanOrEqualTo:
            constraint = self.base.widthAnchor.constraint(greaterThanOrEqualToConstant: constant)
        case .lessThanOrEqualTo:
            constraint = self.base.widthAnchor.constraint(lessThanOrEqualToConstant: constant)
        }
        
        priority.also {
            constraint.priority = $0
        }
        
        constraint.isActive = isActive
        
        return constraint
    }
}

// MARK: - Aspect Ration Constraints
extension Constrained where Base: UIView {
    @discardableResult
    public func ratio(
        ratio: CGFloat,
        relation: ConstrainedRatioRelation = .widthToHeight,
        priority: UILayoutPriority? = nil,
        isActive: Bool = true
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        
        switch relation {
        case .widthToHeight:
            constraint = self.base.widthAnchor.constraint(equalTo: self.base.heightAnchor, multiplier: ratio)
        case .heightToWidth:
            constraint = self.base.heightAnchor.constraint(equalTo: self.base.widthAnchor, multiplier: ratio)
        }
        
        priority.also {
            constraint.priority = $0
        }
        
        constraint.isActive = isActive
        
        return constraint
    }
}
