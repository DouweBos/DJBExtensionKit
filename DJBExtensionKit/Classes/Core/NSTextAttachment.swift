//
//  NSTextAttachment.swift
//  DJBExtentionKit
//
//  Created by Douwe Bos on 14/08/2019.
//  Copyright © 2019 DJBSoftware. All rights reserved.
//

import UIKit

public extension NSTextAttachment {
    static func getCenteredImageAttachment(with imageName: String,
                                           and font: UIFont?) -> NSTextAttachment? {
        
        let imageAttachment = NSTextAttachment()
        guard let image = UIImage(named: imageName),
            let font = font else { return nil }
        
        imageAttachment.bounds = CGRect(x: 0, y: (font.capHeight - image.size.height).rounded() / 2, width: image.size.width, height: image.size.height)
        imageAttachment.image = image
        return imageAttachment
    }
}
