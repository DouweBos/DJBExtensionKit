//
//  UICollectionView.swift
//  DJBExtentionKit
//
//  Created by Douwe Bos on 14/08/2019.
//  Copyright © 2019 DJBSoftware. All rights reserved.
//

import UIKit

public extension UICollectionView {
    
    
    /// Apply Grid layout to UICollectionView
    ///
    /// - Parameters:
    ///   - numberOfGridsPerRow: Number of columns in each row of cells
    ///   - space: Padding between cells and edge inset of entire UICollectionView
    func adaptGrid(numberOfGridsPerRow: Int, gridLineSpace space: CGFloat, cellHeightRatio: CGFloat? = nil) {
        let inset = UIEdgeInsets(
            top: space, left: space, bottom: space, right: space
        )
        adaptGrid(numberOfGridsPerRow: numberOfGridsPerRow, gridLineSpace: space, sectionInset: inset, cellHeightRatio: cellHeightRatio)
    }
    
    
    /// Apply Grid layout to UICollectionView
    ///
    /// - Parameters:
    ///   - numberOfGridsPerRow: Number of columns in each row of cells
    ///   - space: Padding between cells
    ///   - inset: Edge insets of UICollecionView
    func adaptGrid(numberOfGridsPerRow: Int, gridLineSpace space: CGFloat, sectionInset inset: UIEdgeInsets, cellHeightRatio: CGFloat? = nil) {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        guard numberOfGridsPerRow > 0 else {
            return
        }
        let isScrollDirectionVertical = layout.scrollDirection == .vertical
        var length = isScrollDirectionVertical ? self.frame.width : self.frame.height
        length -= space * CGFloat(numberOfGridsPerRow - 1)
        length -= isScrollDirectionVertical ? (inset.left + inset.right) : (inset.top + inset.bottom)
        let side = length / CGFloat(numberOfGridsPerRow)
        guard side > 0.0 else {
            return
        }
        layout.itemSize = CGSize(width: side, height: side * (cellHeightRatio ?? (188.0/104.0)))
        layout.minimumLineSpacing = space
        layout.minimumInteritemSpacing = space
        layout.sectionInset = inset
        layout.invalidateLayout()
    }
    
    func animateChanges(duration: TimeInterval, completion: ((Bool) -> Swift.Void)? = nil) {
        performBatchUpdates({}){ _ in }
        
        let layout = collectionViewLayout
        setCollectionViewLayout(layout, animated: true)
        collectionViewLayout.invalidateLayout()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion?(true)
        }
//
//        UIView.animate(withDuration: duration, animations: { [weak self] in self?.layoutIfNeeded() }, completion: completion)
//        UIView.animate(withDuration: duration, animations: { [weak self] in
//            guard let `self` = self else { return }
//
//            let layout = self.collectionViewLayout
//
//            self.performBatchUpdates({ [weak self] in
//                self?.setCollectionViewLayout(layout, animated: false)
//            }) { [weak self] (completed) in
//                self?.collectionViewLayout.invalidateLayout()
//                completion?(completed)
//            }
//
//        }, completion: nil)
    }
}
