//
//  MarvelAPIComic.swift
//  MarvelComics
//
//  Created by Alexandre Malkov on 22/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import Foundation

/**
 This struct contains comic item data
 - important: I've implemented only TWO fileds, because I do not need other fields for this demo! ;-)
 */
struct MarvelAPIComic: Decodable {
    
    /// The unique ID of the comic resource.
    var id: Int?
    
    /// The representative image for this comic.
    var thumbnail: MarvelAPIImage?
}
