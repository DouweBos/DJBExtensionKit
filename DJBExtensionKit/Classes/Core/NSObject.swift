//
//  NSObject.swift
//  DJBExtensionKit
//
//  Created by Douwe Bos on 3/3/22.
//

import Foundation

public extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
