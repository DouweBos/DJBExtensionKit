//
//  UIImage.swift
//  DJBExtentionKit
//
//  Created by Douwe Bos on 14/08/2019.
//  Copyright © 2019 DJBSoftware. All rights reserved.
//

import UIKit

public extension UIImage {
    class func colorForNavBar(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        //    Or if you need a thinner border :
        //    let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.5)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths[0]
    }
}

#if canImport(KingFisher)

import KingFisher

public extension UIImage {
    class func storeImageInFile(source: String, image: UIImage?) {
        guard let image = image else { return }
        
        ImageCache.default.store(image, forKey: "\(RG_SOURCE_IMAGE_CACHE_FILE)-\(source).png")
//
//        if let data = UIImagePNGRepresentation(image) {
//            let filename = getDocumentsDirectory().appendingPathComponent("\(RG_SOURCE_IMAGE_CACHE_FILE)-\(source).png")
//            try? data.write(to: filename)
//        }
    }
    
    class func getImageFromFile(source: String) -> UIImage? {
        return ImageCache.default.retrieveImageInDiskCache(forKey: "\(RG_SOURCE_IMAGE_CACHE_FILE)-\(source).png")
        
//        let filename = getDocumentsDirectory().appendingPathComponent("\(RG_SOURCE_IMAGE_CACHE_FILE)-\(source).png").path
//
//        if FileManager.default.fileExists(atPath: filename) {
//            return UIImage(contentsOfFile: filename)
//        }
//
//        return nil
    }
    
    class func storeImageInFile(person: String, image: UIImage?) {
        guard let image = image else { return }
        
        ImageCache.default.store(image, forKey: "\(RG_PERSON_IMAGE_CACHE_FILE)-\(person.replacingOccurrences(of: " ", with: "_")).png")
        //
        //        if let data = UIImagePNGRepresentation(image) {
        //            let filename = getDocumentsDirectory().appendingPathComponent("\(RG_SOURCE_IMAGE_CACHE_FILE)-\(source).png")
        //            try? data.write(to: filename)
        //        }
    }
    
    class func getImageFromFile(person: String) -> UIImage? {
        return ImageCache.default.retrieveImageInDiskCache(forKey: "\(RG_PERSON_IMAGE_CACHE_FILE)-\(person.replacingOccurrences(of: " ", with: "_")).png")
        
        //        let filename = getDocumentsDirectory().appendingPathComponent("\(RG_SOURCE_IMAGE_CACHE_FILE)-\(source).png").path
        //
        //        if FileManager.default.fileExists(atPath: filename) {
        //            return UIImage(contentsOfFile: filename)
        //        }
        //
        //        return nil
    }
}
#endif

public extension UIImage {
    
    func imageUpMirror() -> UIImage {
        guard let cgImage = cgImage else { return self }
        return UIImage(cgImage: cgImage, scale: scale, orientation: .upMirrored)
    }
    
    func imageDownMirror() -> UIImage {
        guard let cgImage = cgImage else { return self }
        return UIImage(cgImage: cgImage, scale: scale, orientation: .downMirrored)
    }
    
    func imageLeftMirror() -> UIImage {
        guard let cgImage = cgImage else { return self }
        return UIImage(cgImage: cgImage, scale: scale, orientation: .leftMirrored)
    }
    
    func imageRightMirror() -> UIImage {
        guard let cgImage = cgImage else { return self }
        return UIImage(cgImage: cgImage, scale: scale, orientation: .rightMirrored)
    }
}
