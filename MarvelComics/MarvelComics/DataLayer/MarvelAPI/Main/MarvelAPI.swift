//
//  MarvelAPI.swift
//  MarvelComics
//
//  Created by Alexandre Malkov on 22/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import Foundation

/**
 REST methods supported by Marvel API.
 - important: This is NOT full list of the MarvelAPI REST methods, because In this demo app we will use only the "commics" one ;-)
 */
enum MarvelAPIMethods: String {
    
    /// Fetches lists of comic characters with optional filters. See notes on individual parameters below.
    case characters = "characters"
    
    /// Fetches lists of comics with optional filters. See notes on individual parameters below.
    case commics = "commics"
    
    /// Fetches lists of comic creators with optional filters. See notes on individual parameters below.
    case creators = "creators"
}

class MarvelAPI {
    
    /// Marvel API base url
    let baseURL = "https://gateway.marvel.com:443/v1/public/"
    
    /// Change mockMode property to enable/disable data mocking. Really helps with UnitTesting
    var mockableURLSession = MockableURLSession()
    
    /**
     Add this string to the end of MarvelAPI url for Authentication reasons
     - parameter timeStamp: (Optional) TimeStamp used for UnitTesting
     - parameter publicKey: (Optional) PublicKey used for UnitTesting
     - parameter privateKey: (Optional) PrivateKey used for UnitTesting
     - returns: Authentication string
     */
    static func getAuthenticationSignature(timeStamp: String = String(Int(Date().timeIntervalSince1970)),
                                           publicKey: String = SecretConstants.marvelApiPublicKey,
                                           privateKey: String = SecretConstants.marvelApiPrivateKey) -> String {
        let hash = MD5( timeStamp + privateKey + publicKey ).lowercased()
        return "ts=\(timeStamp)&apikey=\(publicKey)&hash=\(hash)"
    }
    
    /**
     Run dataTask and parse returned web response.
     - important: Do not call this methid directly. Use MarvelAPI methods declared in extensions for each data class.
     - parameter urlRequest: a urlRequest with all necessary Marvel API request data
     - parameter completion: Completion block will return Data and ERROR String.
     */
    func getData(urlRequest: URLRequest, completionHandler: @escaping (Data?, String?) -> Void ) {
        
        /// Log url requested
        print("MarvelAPI request: \(urlRequest.url?.absoluteString ?? "nil")")
        
        let dataTask = mockableURLSession.dataTask(with: urlRequest) { [weak self] (data, urlResponse, error) in
            /// First we get HTTP Status Code
            let statusCode = (urlResponse as? HTTPURLResponse)?.statusCode ?? 0
            guard statusCode == 200 else {
                /// We will only return error STRING here, because this is SIMPLE demo app ...
                var errorString = error?.localizedDescription ?? "StatusCode is \(statusCode)"
                if let data = data, let errorResponse: MarvelAPIErrorResponse = self?.decode(data: data) {
                    errorString = errorResponse.message
                }
                print("ERROR: MarvelAPI.getData() : \(errorString)")
                completionHandler(nil, errorString)
                return
            }
            
            /// If data is nil then we will return some error. Otherwise we will return data wthout an error
            if let data = data {
                completionHandler(data, nil)
            } else {
                completionHandler(nil, "Data is nil")
            }
        }
        dataTask.resume()
    }
    
    /**
     Decode data into an instance of Decodable class or structuire
     - important: Do not call this methid directly. This is intended to be used by GoustoAPI methods declared in extensions for each data class.
     - parameter data: Data that needs to be decoded
     - returns: an instance of Decodable class provided to this Generic function
     */
    func decode<T: Decodable>(data: Data) -> T? {
        
        /// Create decoder with iso8601 Date support
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        /// Add more decoder setting here if needed ......
        
        /// Let's try decode our data
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("ERROR: MarvelAPI.decode(): \(error)")
            print("DATA JSON: \(String(decoding: data, as: UTF8.self))")
            return nil
        }
    }
}
