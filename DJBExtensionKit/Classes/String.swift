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
        do {
            if let s = try staticString?.value(forKeyPath: "\(self).value") as? String {
                return s.replacingOccurrences(of: "\\n", with: "\n")
            } else {
                return self
            }
        } catch let error {
            print(error)
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
    
    
    /// URLEncode `self`
    ///
    /// - Returns: URLENcoded `self`
    func encodeUrl() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
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
    
    func replacingFirstOccurrence(of string: String, with replacement: String) -> String {
        guard let range = self.range(of: string) else { return self }
        return replacingCharacters(in: range, with: replacement)
    }
    
    func getURLScheme() -> String? {
        return self.components(separatedBy: "://").first
    }
}

public extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        var indices: [Index] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                indices.append(range.lowerBound)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return indices
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}

struct Regex {
    private init() {}

    static let ipAddress = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"
    static let hostname = "^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\\-]*[a-zA-Z0-9])\\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\\-]*[A-Za-z0-9])$"
    
    static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
}

public extension String {
    var isValidIpAddress: Bool {
        return self.matches(pattern: Regex.ipAddress)
    }

    var isValidHostname: Bool {
        return self.matches(pattern: Regex.hostname)
    }
    
    var isValidEmail: Bool {
        return self.matches(pattern: Regex.email)
    }

    private func matches(pattern: String) -> Bool {
        return self.range(of: pattern,
                          options: .regularExpression,
                          range: nil,
                          locale: nil) != nil
    }
}

public extension String {
    var isBackspace: Bool {
        let char = self.cString(using: String.Encoding.utf8)!
        return strcmp(char, "\\b") == -92
    }
}

public extension NSAttributedString {
    static func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
        let leftCopy = NSMutableAttributedString(attributedString: left)
        leftCopy.append(right)
        return leftCopy
    }

    static func + (left: NSAttributedString, right: String) -> NSAttributedString {
        let leftCopy = NSMutableAttributedString(attributedString: left)
        let rightAttr = NSMutableAttributedString(string: right)
        leftCopy.append(rightAttr)
        return leftCopy
    }

    static func + (left: String, right: NSAttributedString) -> NSAttributedString {
        let leftAttr = NSMutableAttributedString(string: left)
        leftAttr.append(right)
        return leftAttr
    }
}

public extension NSMutableAttributedString {
    static func += (left: NSMutableAttributedString, right: String) -> NSMutableAttributedString {
        let rightAttr = NSMutableAttributedString(string: right)
        left.append(rightAttr)
        return left
    }

    static func += (left: NSMutableAttributedString, right: NSAttributedString) -> NSMutableAttributedString {
        left.append(right)
        return left
    }
}
