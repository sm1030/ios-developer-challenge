//
//  ComicsListViewController.swift
//  MarvelComics
//
//  Created by Alexandre Malkov on 23/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import UIKit

class ComicsListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var comicsList = [MarvelAPIComic]()
 
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /// Register obesrver for the ComicsManager.comicsListUpdateNotification
        NotificationCenter.default.addObserver(forName: ComicsManager.comicsListUpdateNotification, object: nil, queue: OperationQueue.main) { [weak self] (notification) in
            if let comicsList = notification.object as? [MarvelAPIComic] {
                self?.comicsList = comicsList
                self?.collectionView.reloadData()
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ComicsListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight = (collectionView.frame.height / 3) - 10
        let cellWidth = cellHeight / 1.5
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}

extension ComicsListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ComicsManager.shared.moreItemsAvailable ? comicsList.count + 1 : comicsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        /// Try to return ComicsCell
        if comicsList.count > indexPath.row {
            if let comicsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComicsCell", for: indexPath) as? ComicsCell {
                comicsCell.comic = comicsList[indexPath.row]
                return comicsCell
            }
        }
        
        /// Otherwise return activity cell
        ComicsManager.shared.requestMoreComics()
        if let activityCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityCell", for: indexPath) as? ActivityCell {
            activityCell.activityIndicator.startAnimating()
            return activityCell
        }
        
        /// And if something is terrebly wrong then just return new empty cell
        return UICollectionViewCell()
    }
}
