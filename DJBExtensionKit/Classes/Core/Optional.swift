//
//  Optional.swift
//  DJBExtensionKit
//
//  Created by Douwe Bos on 03/02/2020.
//

import Foundation

public extension Optional {
    
    // Mimics Kotlin's .also behavior
    // Makes sharing code between my Kotlin and Swift projects a lot easier
    func also(handler: ((Wrapped) -> Swift.Void)) {
        if case let Optional.some(value) = self {
            handler(value)
        }
    }
}
