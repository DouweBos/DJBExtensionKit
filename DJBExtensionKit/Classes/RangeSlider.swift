//
//  RangeSlider.swift
//  DJBExtentionKit
//
//  Created by Douwe Bos on 14/08/2019.
//  Copyright © 2019 DJBSoftware. All rights reserved.
//

#if canImport(RangeSeekSlider)
public extension RangeSeekSlider {
    func didSetValues() -> Bool {
        return selectedMinValue != minValue || selectedMaxValue != maxValue
    }
    
    func reset() {
        selectedMinValue = minValue
        selectedMaxValue = maxValue
        refresh()
    }
}
#endif
