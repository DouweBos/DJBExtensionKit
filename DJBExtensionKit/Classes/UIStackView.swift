//
//  UIStackView.swift
//  DJBExtentionKit
//
//  Created by Douwe Bos on 14/08/2019.
//  Copyright © 2019 DJBSoftware. All rights reserved.
//

import UIKit

extension UIStackView {
    func insertArrangedSubviews(_ views: [UIView], at stackIndex: Int) {
        var index = stackIndex
        
        for view in views {
            insertArrangedSubview(view, at: index)
            
            index += 1
        }
    }
    
    func removeAll() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
    
    func replaceSubviews(with views: [UIView]) {
        removeAll()
        
        insertArrangedSubviews(views, at: 0)
    }
}
