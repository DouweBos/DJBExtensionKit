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
