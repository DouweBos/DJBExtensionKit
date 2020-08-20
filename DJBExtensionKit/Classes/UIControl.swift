//
//  UIControl.swift
//  DJBExtensionKit
//
//  Created by Douwe Bos on 20/8/20.
//

import UIKit

@available(iOS 13.4, *)
extension UIControl: UIPointerInteractionDelegate {
    public func enablePointerInteraction() {
        self.addInteraction(UIPointerInteraction(delegate: self))
    }

    // This isn't even needed — just indicating what the default does!
    public func pointerInteraction(_ interaction: UIPointerInteraction, regionFor request: UIPointerRegionRequest, defaultRegion: UIPointerRegion) -> UIPointerRegion? {
        return defaultRegion
    }

    public func pointerInteraction(_ interaction: UIPointerInteraction, styleFor region: UIPointerRegion) -> UIPointerStyle? {
        return UIPointerStyle(effect: .automatic(.init(view: self)))
    }
}
