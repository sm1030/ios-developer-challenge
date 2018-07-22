//
//  MarvelAPIComicsResponse.swift
//  MarvelComics
//
//  Created by Alexandre Malkov on 22/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import Foundation

/**
 This struct contains comics response body
 */
struct MarvelAPIComicsResponse: Decodable {
    
    /// The HTTP status code of the returned result.
    var code: Int?
    
    /// A string description of the call status
    var status: String?
    
    /// The copyright notice for the returned result
    var copyright: String?
    
    /// The attribution notice for this result. Please display either this notice or the contents of the attributionHTML field on all screens which contain data from the Marvel Comics API
    var attributionText: String?
    
    /// An HTML representation of the attribution notice for this result. Please display either this notice or the contents of the attributionText field on all screens which contain data from the Marvel Comics API.
    var attributionHTML: String?
    
    /// The results returned by the call.
    var data: MarvelAPIComicDataContainer?
    
    /// A digest value of the content returned by the call.
    var etag: String?
}

extension MarvelAPI {
    
    /**
     Fetches lists of comics with optional filters.
     - parameter limit: Limit the result set to the specified number of resources.
     - parameter offset: Skip the specified number of resources in the result set.
     - parameter completion: This completion closure will be called as soon operation is completed, sucessfully or not. If it was sucessfull it will return GoustoAPIProductsResponse. Otherwise you will get an ErrorString
     */
    func getComics( limit: Int?, offset: Int?, completion: (( MarvelAPIComicsResponse?, String?) -> Void)? ) {
        
        /// Make URL object
        var urlString = baseURL + MarvelAPIMethods.comics.rawValue + "?" + MarvelAPI.authenticationSignature()
        
        /// If we have limit argument then add it to the query
        if let limit = limit {
            urlString += "&limit=\(limit)"
        }
        
        /// If we have offset argument then add it to the query
        if let offset = offset {
            urlString += "&offset=\(offset)"
        }
        
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
                let comicsResponse: MarvelAPIComicsResponse? = self.decode(data: data)
                DispatchQueue.main.async { completion?( comicsResponse, nil) }
            } else {
                DispatchQueue.main.async { completion?( nil, "Response data is NIL") }
            }
        }
    }
}
