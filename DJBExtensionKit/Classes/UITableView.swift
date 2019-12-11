//
//  UITableView.swift
//  DJBExtentionKit
//
//  Created by Douwe Bos on 14/08/2019.
//  Copyright © 2019 DJBSoftware. All rights reserved.
//

import UIKit

public extension UITableView {
    func register<T: UITableViewCell>(cell: T.Type) {
        register(cell.nib, forCellReuseIdentifier: cell.reuseIdentifier)
    }
}

public extension UITableView {
    func animateChanges(duration: TimeInterval, completion: ((Bool) -> Swift.Void)? = nil) {
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
                        self?.beginUpdates()
                        self?.endUpdates()
                       },
                       completion: completion)
    }
}
