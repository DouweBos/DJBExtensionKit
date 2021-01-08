//
//  DequeueCell.swift
//  DJBExtensionKit
//
//  Created by Douwe Bos on 15/10/20.
//

import Foundation

public protocol HasReuseIdentifier {
    static var reuseIdentifier: String { get }
}

public protocol HasUINib {
    static var nib: UINib { get }
}
