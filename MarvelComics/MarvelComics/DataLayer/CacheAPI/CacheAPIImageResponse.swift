//
//  CacheAPIImageResponse.swift
//  MarvelComics
//
//  Created by Alexandre Malkov on 23/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import UIKit

/**
 This data structure will contain image response with image object and it's url
 */
struct CacheAPIImageResponse {
    
    /// The URL where image was downloaded from
    var imagePath: String = ""
    
    /// The image object
    var image: UIImage?
    
    /// The image size variant
    var sizeVariant: MarvelAPIImageSizeVariant = .fullSize
    
    /// Image returned from cache, not web server
    var isFromCache: Bool
}

/**
 This class returns web resources stored in the NSCache object. If object is not found in the cache then it download new object and updates the cache. Subscribe for notifications to be notified about rosource arrival.
 */
extension CacheAPI {
    
    /**
     Returns UIImage object for requested URL, if it is found in the cache. Otherwise it will call requestImage() method
     - parameter imageURL: URL for the requested image
     - parameter imageExtension: Image type
     - parameter sizeVariant: Image size variant
     - returns: UIImage if it is found in the cache. Otherwise it will call requestImage() method
     */
    func getImage(imagePath: String, imageExtension: String, sizeVariant: MarvelAPIImageSizeVariant) -> UIImage? {

        /// Generate imageCacheKey
        let imageCacheKey = getImageCacheKey(imagePath: imagePath, imageExtension: imageExtension, sizeVariant: sizeVariant)
        
        /// Get the image
        if let chachedImage = imageCache.object(forKey: imageCacheKey) {
            return chachedImage
        } else {
            _ = requestImage(imagePath: imagePath, imageExtension: imageExtension, sizeVariant: sizeVariant)
        }
        
        /// Return nil if something went wrong
        return nil
    }
    
    /**
     Posting imageNotification with requested image. If image is found in the cache then you will get from cache. Otherwise it will be downloaded from requested URL location
     - parameter imagePath: URL for the requested image
     - parameter imageExtension: Image type
     - parameter sizeVariant: Image size variant
     - returns: Return true if there was no error in request preparation and you should expect imageNotification
     */
    func requestImage(imagePath: String, imageExtension: String, sizeVariant: MarvelAPIImageSizeVariant) -> Bool {

        /// Generate imageCacheKey
        let imageCacheKey = getImageCacheKey(imagePath: imagePath, imageExtension: imageExtension, sizeVariant: sizeVariant)

        if let chachedImage = imageCache.object(forKey: imageCacheKey) {

            /// Return image asynchronously from cache
            DispatchQueue.global(qos: .background).async { 
                let imageResponse = CacheAPIImageResponse(imagePath: imagePath, image: chachedImage, sizeVariant: sizeVariant, isFromCache: true)
                NotificationCenter.default.post(name: CacheAPI.imageNotification, object: imageResponse)
            }
        } else {

            /// Download image from the Marval WebServer
            marvelAPI.getImage(imagePath: imagePath, imageExtension: imageExtension, sizeVariant: sizeVariant, completion: { (image, errorString) in
                
                /// Make sure that image is not nil
                guard let image = image else {
                    print("ERROR: CacheAPI.requestImage() response image is NIL")
                    return
                }
                
                /// Save image to cache
                self.imageCache.setObject(image, forKey: imageCacheKey)
                
                /// Return this image to
                let imageResponse = CacheAPIImageResponse(imagePath: imagePath, image: image, sizeVariant: sizeVariant, isFromCache: false)
                NotificationCenter.default.post(name: CacheAPI.imageNotification, object: imageResponse)
            })
        }
        return true
    }
    
    /**
     Generate unque image cache key using imageURL and sizeVariant
     - parameter imagePath: URL for the requested image
     - parameter sizeVariant: Image size variant
     - returns: Image cache key
     */
    private func getImageCacheKey(imagePath: String, imageExtension: String, sizeVariant: MarvelAPIImageSizeVariant) -> NSString {
        return NSString(string: "imagePath:\(imagePath) imageExtension:\(imageExtension) sizeVariant:\(sizeVariant.rawValue)")
    }
}
