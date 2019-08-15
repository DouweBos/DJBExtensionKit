//
//  UIViewController.swift
//  DJBExtentionKit
//
//  Created by Douwe Bos on 14/08/2019.
//  Copyright © 2019 DJBSoftware. All rights reserved.
//

import UIKit


public extension UIViewController {
    
    /// Get ClassName for UIViewController
    var className: String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last ?? "UIViewController";
    }
}

public extension UIViewController {
    
    /// Initialize a UIViewController from storyboard with given name. Will crash if storyboard does not exist or has no initial viewcontroller
    ///
    /// - Parameter name: Name of storyboard whose initial viewcontroller will return
    /// - Returns: Initial viewcontroller of given storyboard
    static func fromStoryboard(name: String) -> UIViewController {
        return UIStoryboard(name: name, bundle: nil).instantiateInitialViewController()!
    }
    
    var isModal: Bool {
        return self.presentingViewController?.presentedViewController == self
            || (self.navigationController != nil && self.navigationController?.presentingViewController?.presentedViewController == self.navigationController)
            || self.tabBarController?.presentingViewController is UITabBarController
    }
}

//Override URLNavigator's topMost UIViewController extension
extension UIViewController {
    
    /// Returns the current application's top most view controller.
    open class var topMost: UIViewController? {
        var rootViewController: UIViewController?
        let currentWindows = UIApplication.shared.windows
        
        for window in currentWindows {
            if let windowRootViewController = window.rootViewController {
                rootViewController = windowRootViewController
                break
            }
        }
        
        return self.topMost(of: rootViewController)
    }
    
    /// Returns the top most view controller from given view controller's stack.
    open class func topMost(of viewController: UIViewController?) -> UIViewController? {
        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return self.topMost(of: selectedViewController)
        }
        
        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return self.topMost(of: visibleViewController)
        }
        
        // presented view controller
        if let presentedViewController = viewController?.presentedViewController {
            return self.topMost(of: presentedViewController)
        }
        
        return viewController
    }
    
}
