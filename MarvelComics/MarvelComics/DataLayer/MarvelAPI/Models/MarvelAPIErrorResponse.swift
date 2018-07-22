//
//  MarvelAPIErrorResponse.swift
//  MarvelComics
//
//  Created by Alexandre Malkov on 22/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import Foundation

/**
 This structure represent Marvel API error response
 */
struct MarvelAPIErrorResponse: Decodable {
    
    /// Error code text ?!? :-)
    var code: String
    
    /// Error message
    var message: String
}
