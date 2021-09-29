//
//  Kingfisher.swift
//  DJBExtentionKit
//
//  Created by Douwe Bos on 14/08/2019.
//  Copyright © 2019 DJBSoftware. All rights reserved.
//

import Kingfisher
import RxSwift

public extension KingfisherWrapper where Base: KFCrossPlatformImageView {
    func setImage(
        with resource: Resource?,
        placeholder: UIImage? = nil,
        options: KingfisherOptionsInfo? = nil,
        progressBlock: DownloadProgressBlock? = nil,
        faceAware: Bool = false,
        imageFailCheck: @escaping (() -> Bool) = { return true },
        completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil
    ) {
        
        DispatchQueue.main.async {
            self.base.image = placeholder ?? self.base.image
            
            DispatchQueue.global(qos: .userInitiated).async {
                guard let resource = resource else { return }
                
                //Cause of cell reusability and the images loading async I had to add an imageFailCheck code block to the setImage function
                //ImageFailCheck has to return if an image is still allowed to be set
                //So as an example: make a cell compare it's local rgID variable to the rgID the cell had when it started the async setImage call
                //If the rgIDs don't match the cell has been reused by now and the image should no longer be set
                KingfisherManager.shared.retrieveImage(
                    with: resource,
                    options: options,
                    progressBlock: progressBlock) { (result) in
                        switch result {
                        case .success(let imageResult):
                            DispatchQueue.main.async {
                                if imageFailCheck() {
                                    if faceAware {
                                        self.base.set(image: imageResult.image, focusOnFaces: true)
                                    } else {
                                        self.base.image = imageResult.image
                                    }
                                    
                                    completionHandler?(result)
                                } else {
                                    print("Did fail image check: \(resource)")
                                }
                            }
                        case .failure:
                            DispatchQueue.main.async {
                                completionHandler?(result)
                            }
                        }
                    }
            }
        }
    }
    
    func setImage(
        with resources: [Resource?]?,
        placeholder: UIImage? = nil,
        options: KingfisherOptionsInfo? = nil,
        progressBlock: DownloadProgressBlock? = nil,
        faceAware: Bool = false,
        imageFailCheck: @escaping (() -> Bool) = { return true },
        completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil
    ) {
        
        DispatchQueue.main.async {
            self.base.image = placeholder ?? self.base.image
            
            DispatchQueue.global(qos: .userInitiated).async {
                if let resources = resources, let resource = resources.first {
                    guard let resource = resource else { return }
                    
                    //Cause of cell reusability and the images loading async I had to add an imageFailCheck code block to the setImage function
                    //ImageFailCheck has to return if an image is still allowed to be set
                    //So as an example: make a cell compare it's local rgID variable to the rgID the cell had when it started the async setImage call
                    //If the rgIDs don't match the cell has been reused by now and the image should no longer be set
                    KingfisherManager.shared.retrieveImage(with: resource,
                                                           options: options,
                                                           progressBlock: progressBlock) { (result) in
                        switch result {
                        case .success(let imageResult):
                            DispatchQueue.main.async {
                                if imageFailCheck() {
                                    if faceAware {
                                        self.base.set(image: imageResult.image, focusOnFaces: true)
                                    } else {
                                        self.base.image = imageResult.image
                                    }
                                    
                                    completionHandler?(result)
                                } else {
                                    print("Did fail image check: \(resource)")
                                }
                            }
                        case .failure:
                            DispatchQueue.main.async {
                                self.setImage(with: Array(resources.dropFirst()),
                                              placeholder: placeholder,
                                              options: options,
                                              progressBlock: progressBlock,
                                              imageFailCheck: imageFailCheck,
                                              completionHandler: completionHandler)
                            }
                        }
                    }
                }
            }
        }
    }
}

public extension KingfisherManager {
    func retrieveImage(
        with resources: [Resource],
        options: KingfisherOptionsInfo? = nil,
        progressBlock: DownloadProgressBlock? = nil,
        imageFailCheck: @escaping (() -> Bool) = { return true },
        completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil
    ) {
        if let resource = resources.first {
            retrieveImage(with: resource, options: options, progressBlock: progressBlock) { (result) in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        if imageFailCheck() {
                            completionHandler?(result)
                        } else {
                            print("Did fail image check: \(resource)")
                        }
                    }
                case .failure:
                    DispatchQueue.main.async {
                        self.retrieveImage(with: Array(resources.dropFirst()),
                                           options: options,
                                           progressBlock: progressBlock,
                                           imageFailCheck: imageFailCheck,
                                           completionHandler: completionHandler)
                    }
                }
            }
        }
    }
}

extension Reactive where Base == KingfisherManager {
    public func retrieveImage(
        with resources: [Resource],
        options: KingfisherOptionsInfo? = nil,
        progressBlock: DownloadProgressBlock? = nil,
        imageFailCheck: @escaping (() -> Bool) = { return true }
    ) -> Observable<KFCrossPlatformImage?> {
        return Observable.create { [base] emitter in
            var task: DownloadTask? = nil
            
            if let resource = resources.first {
                task = base.retrieveImage(
                    with: resource,
                    options: options
                ) { result in
                    switch result {
                    case .success(let value):
                        emitter.onNext(value.image)
                    case .failure(let error):
                        emitter.onError(error)
                    }
                }
            } else {
                emitter.onNext(nil)
            }
            
            return Disposables.create { task?.cancel() }
        }
            .catch { _ in
                return retrieveImage(
                    with: Array(resources.dropFirst()),
                    options: options,
                    progressBlock: progressBlock,
                    imageFailCheck: imageFailCheck
                )
            }
    }
}
