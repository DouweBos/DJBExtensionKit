//
//  UITableViewCell.swift
//  DJBExtensionKit
//
//  Created by Douwe Bos on 10/12/2019.
//

import UIKit

extension UITableViewCell: HasReuseIdentifier {
    public static var reuseIdentifier: String {
        get {
            return "\(type(of: self))"
        }
    }
}

extension UITableViewCell: HasUINib {
    public static var nib: UINib {
        return UINib(nibName: "\(type(of: self))", bundle: nil)
    }
}
