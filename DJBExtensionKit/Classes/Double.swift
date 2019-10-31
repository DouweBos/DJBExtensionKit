//
//  Double.swift
//  DJBExtensionKit
//
//  Created by Douwe Bos on 31/10/2019.
//

import Foundation

public extension Double {
    func roundToDecimals(decimals: Int = 2) -> Double {
        let multiplier = Double(pow(10.0, Double(decimals)))
        return (multiplier * self).rounded() / multiplier
    }
}
