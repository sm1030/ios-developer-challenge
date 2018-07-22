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
    
    /// Error code text ?!? Do not ask me why this "code" is String and returns TEXT DESCRIPTION!   :-)
    var code: String
    
    /// Error message
    var message: String
}
