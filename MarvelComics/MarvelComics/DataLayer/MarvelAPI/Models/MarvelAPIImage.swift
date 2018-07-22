//
//  MarvelAPIImage.swift
//  MarvelComics
//
//  Created by Alexandre Malkov on 22/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import Foundation

/**
 The representative image
 */
struct MarvelAPIImage: Decodable {
    
    /// The directory path of to the image.
    var path: String?
    
    /// The file extension for the image
    var imageExtension: String?
    
    /// We have to use this because word "extension" is reserved word in SWIFT
    private enum CodingKeys : String, CodingKey {
        case path
        case imageExtension = "extension"
    }
}
