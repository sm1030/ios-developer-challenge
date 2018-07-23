//
//  ComicsManager.swift
//  MarvelComics
//
//  Created by Alexandre Malkov on 23/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import Foundation

class ComicsManager {
    
    /// Shared instance
    static let shared = ComicsManager()
    
    /// Notification name for category list update event
    static let comicsListUpdateNotification = Notification.Name("ComicsManager_ComicsListUpdateNotification")
    
    /// Latest full comics list
    private var comicsList = [MarvelAPIComic]()
    
    /// This flag indicates if more items is available on the server
    var moreItemsAvailable = true
    
    /// Comics object selected by the user
    var selectedComics: MarvelAPIComic?
    
    /// Class initialization
    init() {
        requestMoreComics()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// Request comics list to extend one we have already
    func requestMoreComics() {
        MarvelAPI.shared.getComics(limit: 20, offset: comicsList.count) { [weak self] (comicsResponse, errorString) in
            
            guard let strongSelf = self else {
                return
            }
            
            guard let responseDataOffset = comicsResponse?.data?.offset else {
                print("ERROR: ComicsManager.requestMoreComics() responseDataOffset is NIL")
                return
            }
            
            guard let responseDataTotal = comicsResponse?.data?.total else {
                print("ERROR: ComicsManager.requestMoreComics() responseDataTotal is NIL")
                return
            }
            
            guard responseDataOffset == strongSelf.comicsList.count else {
                print("ERROR: ComicsManager.requestMoreComics() dataOffset \(responseDataOffset) is not equal to expected comicsList.count \(strongSelf.comicsList.count)")
                return
            }
            
            guard let responseDataResults = comicsResponse?.data?.results else {
                print("ERROR: ComicsManager.requestMoreComics() responseDataResults is NIL")
                return
            }
            
            /// Extend comicsList
            strongSelf.comicsList += responseDataResults
            strongSelf.moreItemsAvailable = responseDataTotal > strongSelf.comicsList.count
            
            NotificationCenter.default.post(name: ComicsManager.comicsListUpdateNotification, object: strongSelf.comicsList)
        }
    }
}
