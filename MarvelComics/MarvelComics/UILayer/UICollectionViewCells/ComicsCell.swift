//
//  ComicsCell.swift
//  MarvelComics
//
//  Created by Alexandre Malkov on 23/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import UIKit

class ComicsCell: UICollectionViewCell {
    
    @IBOutlet weak var comicsImageView: UIImageView!
    @IBOutlet weak var comicsImageActivityIndicator: UIActivityIndicatorView!
    
    var observingImageNotification = false
    var comicImagePath: String?
    var comicImageSizeVariant: MarvelAPIImageSizeVariant = .portraitXlarge
    
    var comic: MarvelAPIComic? {
        didSet {
            
            /// Request image
            if let imagePath = comic?.thumbnail?.path, let imageExtension = comic?.thumbnail?.imageExtension {
                subscribeForImageUpdatesIfNeeded()
                comicsImageActivityIndicator.startAnimating()
                comicImagePath = imagePath
                comicImageSizeVariant = UIScreen.main.bounds.height > UIScreen.main.bounds.width ? .portraitXlarge : .portraitUncanny
                _ = CacheAPI.shared.requestImage(imagePath: imagePath, imageExtension: imageExtension, sizeVariant: comicImageSizeVariant)
            } else {
                comicsImageActivityIndicator.stopAnimating()
                comicsImageView.image = #imageLiteral(resourceName: "image_not_available_portrait_medium")
            }
        }
    }
    
    /**
     Cancel image request
     */
    override func prepareForReuse() {
        comicImagePath = nil
        comicsImageView.image = nil
    }
    
    /**
     This will handle image update notification
     */
    func subscribeForImageUpdatesIfNeeded() {
        if observingImageNotification == false {
            observingImageNotification = true
            NotificationCenter.default.addObserver(forName: CacheAPI.imageNotification, object: nil, queue: OperationQueue.main) { [weak self] (notification) in
                if let imageResponse = notification.object as? CacheAPIImageResponse {
                    if let requestedImagePath = self?.comicImagePath, let comicImageSizeVariant = self?.comicImageSizeVariant, requestedImagePath == imageResponse.imagePath && imageResponse.sizeVariant == comicImageSizeVariant {
                        self?.comicsImageActivityIndicator.stopAnimating()
                        if let image = imageResponse.image {
                            self?.comicsImageView?.image = image
                        }
                    }
                }
            }
        }
    }
    
    /**
     Unsubscribing from notifications
     */
    deinit {
        observingImageNotification = false
        NotificationCenter.default.removeObserver(self)
    }
}
