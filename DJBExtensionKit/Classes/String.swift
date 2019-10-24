//
//  String.swift
//  DJBExtentionKit
//
//  Created by Douwe Bos on 14/08/2019.
//  Copyright © 2019 DJBSoftware. All rights reserved.
//

import Foundation
import UIKit

public var LOCALIZED_STRINGS_DICTIONARY: NSDictionary?

public extension String {
    static func setLocalizedStringsDictionary(with value: NSDictionary) {
        LOCALIZED_STRINGS_DICTIONARY = value
    }
    
    /// Returns localized string for given keypath. Strings are stored in RGString.plist
    ///
    /// - Parameter keyPath: key under which the localized string is stored
    /// - Returns: Localized string for key, if no localized string exists it returns the key
    static func localizedString(for keyPath: String, from staticString: NSDictionary? = LOCALIZED_STRINGS_DICTIONARY) -> String {
        if let s = staticString?.value(forKeyPath: "\(keyPath).value") as? String {
            return s.replacingOccurrences(of: "\\n", with: "\n")
        } else {
            return keyPath
        }
    }
    
    
    /// Returns localized string using `self` as key
    ///
    /// - Returns: Localized string for `self`, if no key exists it returns `self`
    func localized(from staticString: NSDictionary? = LOCALIZED_STRINGS_DICTIONARY) -> String {
        if let s = staticString?.value(forKeyPath: "\(self).value") as? String {
            return s.replacingOccurrences(of: "\\n", with: "\n")
        } else {
            return self
        }
    }
    
    
    /// Append to a string from the left untill it's at least a given size in length
    ///
    /// - Parameters:
    ///   - width: Minumum required characters
    ///   - padString: String to append `self` with
    /// - Returns: Leftpadded string
    func leftPad(toWidth width: Int, withString padString: String) -> String {
        guard self.count < width else { return self }
        let remainingLength: Int = width - self.count
        return [String(repeating: padString, count: remainingLength), self].joined(separator: "")
    }
    
    
    /// Check if `self` is a valid email address
    ///
    /// - Returns: Boolean if `self` is valid email address
    func isValidEmail() -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    
    /// URLEncode `self`
    ///
    /// - Returns: URLENcoded `self`
    func encodeUrl() -> String {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? self
    }
    
    
    /// URLDecode `self`
    ///
    /// - Returns: URLDecoded `self`
    func decodeUrl() -> String {
        return self.removingPercentEncoding ?? self
    }
    
    
    /// Get Size of self with given font
    ///
    /// - Parameter font: font to calculate size for
    /// - Returns: size of text
    func size(font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
    }
    
    
    /// Get Size of self with given font and width
    ///
    /// - Parameters:
    ///   - font: font to calculate size for
    ///   - width: width the string will be constrained to
    ///   - numberOfLines: numberOfLines the string will be constrained to
    /// - Returns: height of text
    func size (font: UIFont, constrainedToWidth width: CGFloat, numberOfLines: Int, labelType: UILabel.Type = UILabel.self) -> CGRect {
        let label = labelType.init(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = numberOfLines
        label.text = self
        label.font = font
        label.sizeToFit()
        
        return label.frame
    }
    
    
    /// Replace target String with new String
    ///
    /// - Parameters:
    ///   - target: target to replace
    ///   - with: string to replace it with
    mutating func replace(_ target:String, with: String) {
        while let r = self.range(of: target) {
            self.replaceSubrange(r, with: with)
        }
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
