//
//  Kingfisher.swift
//  DJBExtentionKit
//
//  Created by Douwe Bos on 14/08/2019.
//  Copyright © 2019 DJBSoftware. All rights reserved.
//

#if canImport(Kingfisher)
import Kingfisher

public extension Kingfisher where Base: ImageView {
    public func setSourceImage(for source: String,
                               imageFailCheck: @escaping (() -> Bool) = { return true }) {
        let sourceImageUrl = URL(string: RGSettingsService.remoteSourceImageUrl(for: source))
        self.setImage(with: sourceImageUrl,
                      placeholder: UIImage.placeholderImageForSource(source: source),
                      imageFailCheck: imageFailCheck)
    }
    
    public func setMediaImage(for item: String) {
        //let sourceImageUrl = URL(string: RGSettingsService.remoteSourceImageUrl(for: source))
        //self.setImage(with: sourceImageUrl, placeholder: UIImage.placeholderImageForSource(source: source), options: nil, progressBlock: nil, completionHandler: nil)
    }
}

public extension Kingfisher where Base: Button {
    public func setSourceImage(for source: String, controlState: UIControl.State) {
        let sourceImageUrl = URL(string: RGSettingsService.remoteSourceImageUrl(for: source))
        
        guard source != RG_SOURCE_BUY_KEY &&
            source != RG_SOURCE_RENT_KEY &&
            source != RG_SOURCE_MORE_KEY
            else {
                self.base.setImage(UIImage.placeholderImageForSource(source: source), for: .normal)
                return
        }
        
        self.setBackgroundImage(with: sourceImageUrl,
                                for: controlState,
                                placeholder: UIImage.placeholderImageForSource(source: source),
                                options: nil,
                                progressBlock: nil,
                                completionHandler: nil)
    }
    
    public func setMediaImage(for item: String) {
        //let sourceImageUrl = URL(string: RGSettingsService.remoteSourceImageUrl(for: source))
        //self.setImage(with: sourceImageUrl, placeholder: UIImage.placeholderImageForSource(source: source), options: nil, progressBlock: nil, completionHandler: nil)
    }
}

public extension Kingfisher where Base: ImageView {
    public func setImage(with resource: Resource?,
                         placeholder: UIImage? = nil,
                         options: KingfisherOptionsInfo? = nil,
                         progressBlock: DownloadProgressBlock? = nil,
                         imageFailCheck: @escaping (() -> Bool) = { return true },
                         completionHandler: CompletionHandler? = nil)
    {
        DispatchQueue.main.async {
            self.base.image = placeholder ?? self.base.image
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let resource = resource else { return }
            
            //Cause of cell reusability and the images loading async I had to add an imageFailCheck code block to the setImage function
            //ImageFailCheck has to return if an image is still allowed to be set
            //So as an example: make a cell compare it's local rgID variable to the rgID the cell had when it started the async setImage call
            //If the rgIDs don't match the cell has been reused by now and the image should no longer be set
            KingfisherManager.shared.retrieveImage(with: resource,
                                                   options: options,
                                                   progressBlock: progressBlock) { (image, error, cacheType, imageURL) in
                                                    if let _ = error {
                                                        DispatchQueue.main.async {
                                                            completionHandler?(image, error, cacheType, imageURL)
                                                        }
                                                    } else {
                                                        DispatchQueue.main.async {
                                                            if imageFailCheck() {
                                                                self.base.image = image
                                                                
                                                                completionHandler?(image, error, cacheType, imageURL)
                                                            } else {
                                                                //print("Did fail image check: \(imageURL?.absoluteString ?? "No URL")")
                                                            }
                                                        }
                                                    }
            }
        }
    }
    
    public func setImage(with resources: [Resource?]?,
                         placeholder: UIImage? = nil,
                         options: KingfisherOptionsInfo? = nil,
                         progressBlock: DownloadProgressBlock? = nil,
                         imageFailCheck: @escaping (() -> Bool) = { return true },
                         completionHandler: CompletionHandler? = nil)
    {
        DispatchQueue.main.async {
            self.base.image = placeholder ?? self.base.image
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let resources = resources, let resource = resources.first {
                guard let resource = resource else { return }
                
                //Cause of cell reusability and the images loading async I had to add an imageFailCheck code block to the setImage function
                //ImageFailCheck has to return if an image is still allowed to be set
                //So as an example: make a cell compare it's local rgID variable to the rgID the cell had when it started the async setImage call
                //If the rgIDs don't match the cell has been reused by now and the image should no longer be set
                KingfisherManager.shared.retrieveImage(with: resource,
                                                       options: options,
                                                       progressBlock: progressBlock) { (image, error, cacheType, imageURL) in
                                                        if let _ = error {
                                                            DispatchQueue.main.async {
                                                                self.setImage(with: Array(resources.dropFirst()),
                                                                              placeholder: placeholder,
                                                                              options: options,
                                                                              progressBlock: progressBlock,
                                                                              imageFailCheck: imageFailCheck,
                                                                              completionHandler: completionHandler)
                                                            }
                                                        } else {
                                                            DispatchQueue.main.async {
                                                                if imageFailCheck() {
                                                                    self.base.image = image
                                                                    
                                                                    completionHandler?(image, error, cacheType, imageURL)
                                                                } else {
                                                                    //print("Did fail image check: \(imageURL?.absoluteString ?? "No URL")")
                                                                }
                                                            }
                                                        }
                }
                
                
                //This is an old implementation of setting multiple resources to an image.
                //I keep this around just in case something changes but the above implementation is sufficient for now
                //            self.setImage(with: resource,
                //                          placeholder: placeholder,
                //                          options: options,
                //                          progressBlock: progressBlock) { image, error, cacheType, imageURL in
                //                            if let _ = error {
                //                                self.setImage(with: Array(resources.dropFirst()),
                //                                              placeholder: placeholder,
                //                                              options: options,
                //                                              progressBlock: progressBlock,
                //                                              completionHandler: completionHandler)
                //                            } else {
                //                                completionHandler?(image, error, cacheType, imageURL)
                //                            }
                //                          }
            }
        }
    }
}
#endif
