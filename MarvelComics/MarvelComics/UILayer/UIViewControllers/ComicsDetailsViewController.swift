//
//  ComicsDetailsViewController.swift
//  MarvelComics
//
//  Created by Alexandre Malkov on 23/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import UIKit

class ComicsDetailsViewController: UIViewController {
    
    @IBOutlet weak var comicsImageView: UIImageView!
    @IBOutlet weak var comicsImageActivityIndicator: UIActivityIndicatorView!
    
    var comic: MarvelAPIComic?
    var comicImagePath: String?
    
    /**
     Unsubscribing from notifications
     */
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Register obesrver for the ComicsManager.comicsListUpdateNotification
        NotificationCenter.default.addObserver(forName: CacheAPI.imageNotification, object: nil, queue: OperationQueue.main) { [weak self] (notification) in
            if let imageResponse = notification.object as? CacheAPIImageResponse {
                if let requestedImagePath = self?.comicImagePath, requestedImagePath == imageResponse.imagePath && imageResponse.sizeVariant == .fullSize {
                    self?.comicsImageActivityIndicator.stopAnimating()
                    if let image = imageResponse.image {
                        self?.comicsImageView?.image = image
                    }
                }
            }
        }
        
        /// Request selected comics
        comic = ComicsManager.shared.selectedComics
        if let imagePath = comic?.thumbnail?.path, let imageExtension = comic?.thumbnail?.imageExtension {
            comicsImageActivityIndicator.startAnimating()
            comicImagePath = imagePath
            _ = CacheAPI.shared.requestImage(imagePath: imagePath, imageExtension: imageExtension, sizeVariant: .fullSize)
        } else {
            comicsImageActivityIndicator.stopAnimating()
            comicsImageView.image = #imageLiteral(resourceName: "image_not_available_portrait_medium")
        }
    }
    
    @IBAction func panAction(_ sender: UIPanGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
}
