//
//  Bool.swift
//  DJBExtentionKit
//
//  Created by Douwe Bos on 14/08/2019.
//  Copyright © 2019 DJBSoftware. All rights reserved.
//

import Foundation

public extension Bool {
    var intValue: Int {
        return self ? 1 : 0
    }
}
