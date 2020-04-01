//
//  UIWindow.swift
//  DJBExtensionKit
//
//  Created by Douwe Bos on 13/12/2019.
//

import UIKit

public extension UIWindow {
    func toast(
        message: String,
        font: UIFont,
        textColor: UIColor,
        backgroundColor: UIColor,
        bottom: CGFloat = 100,
        cornerRadius: CGFloat = 20.0
    ) {

        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = backgroundColor
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = cornerRadius
        toastContainer.clipsToBounds  =  true
        toastContainer.layer.masksToBounds = true
        
        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = textColor
        toastLabel.textAlignment = .center
        toastLabel.font = font
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0
        toastLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.lineHeightMultiple = CGFloat(1.25)
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let attrString = NSMutableAttributedString(string: message)
        attrString.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        toastLabel.attributedText = attrString
        
        toastContainer.addSubview(toastLabel)
        self.addSubview(toastContainer)
        
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let centerX = NSLayoutConstraint(item: toastLabel,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: toastContainer,
                                         attribute: .centerXWithinMargins,
                                         multiplier: 1,
                                         constant: 0
        )
        let lableBottom = NSLayoutConstraint(item: toastLabel,
                                             attribute: .bottom,
                                             relatedBy: .equal,
                                             toItem: toastContainer,
                                             attribute: .bottom,
                                             multiplier: 1,
                                             constant: -12
        )
        let lableTop = NSLayoutConstraint(item: toastLabel,
                                          attribute: .top,
                                          relatedBy: .equal,
                                          toItem: toastContainer,
                                          attribute: .top,
                                          multiplier: 1,
                                          constant: 12
        )
        let lableLeft = NSLayoutConstraint(item: toastLabel,
                                           attribute: .left,
                                           relatedBy: .equal,
                                           toItem: toastContainer,
                                           attribute: .left,
                                           multiplier: 1,
                                           constant: 16
        )
        let lableRight = NSLayoutConstraint(item: toastLabel,
                                            attribute: .right,
                                            relatedBy: .equal,
                                            toItem: toastContainer,
                                            attribute: .right,
                                            multiplier: 1,
                                            constant: -16
        )
        toastContainer.addConstraints([centerX, lableBottom, lableTop, lableLeft, lableRight])
        
        let containerCenterX = NSLayoutConstraint(item: toastContainer,
                                                  attribute: .centerX,
                                                  relatedBy: .equal,
                                                  toItem: self,
                                                  attribute: .centerX,
                                                  multiplier: 1,
                                                  constant: 0
        )
        let containerBottom = NSLayoutConstraint(item: toastContainer,
                                                 attribute: .bottom,
                                                 relatedBy: .equal,
                                                 toItem: self,
                                                 attribute: .bottom,
                                                 multiplier: 1,
                                                 constant: -1 * bottom
        )
        let containerLeft = NSLayoutConstraint(item: toastContainer,
                                               attribute: .right,
                                               relatedBy: .greaterThanOrEqual,
                                               toItem: self,
                                               attribute: .left,
                                               multiplier: 1,
                                               constant: 16
        )
        let containerRight = NSLayoutConstraint(item: toastContainer,
                                                attribute: .right,
                                                relatedBy: .lessThanOrEqual,
                                                toItem: self,
                                                attribute: .right,
                                                multiplier: 1,
                                                constant: -16
        )
        self.addConstraints([containerCenterX, containerBottom, containerLeft, containerRight])
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
}
