//
//  TimeInterval.swift
//  DJBExtensionKit
//
//  Created by Douwe Bos on 3/3/22.
//

import Foundation

public extension TimeInterval {
    func format(
        using units: NSCalendar.Unit,
        addMiliSeconds: Bool = false
    ) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad
        formatter.allowsFractionalUnits = true
        
        guard var result = formatter.string(from: self) else { return nil }
        
        if addMiliSeconds && units.contains(.second) {
            let fractionalPart = NSNumber(value: self.truncatingRemainder(dividingBy: 1))
            
            let integer = Int(fractionalPart.doubleValue * 1000)
            
            switch formatter.unitsStyle {
            case .spellOut:
                let formatter = NumberFormatter()
                formatter.numberStyle = .spellOut
                
                if let spelledOut = formatter.string(from: NSNumber(value: integer)) {
                    result += " \(spelledOut) miliseconds"
                }
            case .full:
                result += " \(integer) miliseconds"
            case .short:
                result += " \(integer) ms"
            case .brief:
                result += " \(integer)ms"
            case .abbreviated:
                result += " \(integer)ms"
            case .positional:
                let fraction = NumberFormatter()
                fraction.maximumIntegerDigits = 0
                fraction.minimumFractionDigits = 0
                fraction.maximumFractionDigits = 3
                fraction.alwaysShowsDecimalSeparator = false
                
                if let fractionString = fraction.string(from: fractionalPart) {
                    result += fractionString
                }
            @unknown default:
                break
            }
        }
        
        
        return result
    }
}
