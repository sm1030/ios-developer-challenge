//
//  MarvelAPIComicDataContainer.swift
//  MarvelComics
//
//  Created by Alexandre Malkov on 22/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import Foundation

/**
 The results returned by the comics call.
 */
struct MarvelAPIComicDataContainer: Decodable {
    
    /// The requested offset (number of skipped results) of the call.
    var offset: Int?
    
    /// The requested result limit.
    var limit: Int?
    
    /// The total number of resources available given the current filter set.
    var total: Int?
    
    /// The total number of results returned by this call.
    var count: Int?
    
    /// The list of comics returned by the call
    var results: [MarvelAPIComic]?
}
