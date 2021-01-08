//
//  Kingfisher.swift
//  DJBExtentionKit
//
//  Created by Douwe Bos on 14/08/2019.
//  Copyright © 2019 DJBSoftware. All rights reserved.
//

import Nuke

public extension UIImageView {
    func loadImage(with request: ImageRequestConvertible,
                          options: ImageLoadingOptions = ImageLoadingOptions.shared,
                          progress: ImageTask.ProgressHandler? = nil,
                          completion: ImageTask.Completion? = nil) -> ImageTask? {
        Nuke.loadImage(
            with: request,
            options: options,
            into: self,
            progress: progress,
            completion: completion
        )
    }
}
