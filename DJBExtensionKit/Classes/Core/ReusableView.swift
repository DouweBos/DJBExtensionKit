//
//  ReusableView.swift
//  DJBExtensionKit
//
//  Created by Douwe Bos on 29/9/21.
//

import Foundation
import UIKit

@objc public protocol ReusableView: AnyObject {
    func prepareForReuse()
}
