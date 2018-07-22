//
//  MarvelAPIImageResponse.swift
//  MarvelComics
//
//  Created by Alexandre Malkov on 22/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import UIKit

/**
 Image size variants
 */
enum MarvelAPIImageSizeVariant: String {
    
    /// Original size
    case fullSize = "."
    
    /// 50x75px
    case portraitSmall = "/portrait_small."
    
    /// 100x150px
    case portraitMedium = "/portrait_medium."
    
    /// 300x450px
    case portraitUncanny = "/portrait_uncanny."
}

extension MarvelAPI {
    
    /**
     Fetches lists of comics with optional filters.
     - parameter imagePath: Image URL
     - parameter imageExtension: Image type
     - parameter completion: This completion closure will be called as soon operation is completed, sucessfully or not. If it was sucessfull it will return GoustoAPIProductsResponse. Otherwise you will get an ErrorString
     */
    func getImage( imagePath: String, imageExtension: String, sizeVariant: MarvelAPIImageSizeVariant, completion: (( UIImage?, String?) -> Void)? ) {
        
        /// Construct full image path
        let urlString = imagePath.replacingOccurrences(of: "http://", with: "https://") + sizeVariant.rawValue + imageExtension
        
        /// Make sure our URL is valid
        guard let url = URL(string: urlString) else {
            print("ERROR: getEmbededPage() can't create URL object based on url string \"\(urlString)\"")
            completion?(nil, "Bad url: \(urlString)")
            return
        }
        
        /// Create URLRequest
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        /// Run dataTask and parse response data
        getData(urlRequest: urlRequest) { (data, errorString) in
            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async { completion?( image, nil) }
            } else {
                DispatchQueue.main.async { completion?( nil, "Response data is NIL") }
            }
        }
    }
}
