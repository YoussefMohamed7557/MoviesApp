//
//  CollectionViewController.swift
//  networkingWithDelegation
//
//  Created by Yossef on 3/17/21.
//  Copyright © 2021 Yossef. All rights reserved.
//

import UIKit

private let reuseIdentifier = "collectionCell"


class CollectionViewController: UICollectionViewController {

    var collectionMoviesArray : [Movie] = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return collectionMoviesArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)as!CollectionViewCell
        // Configure the cell
        cell.titleLabel.text = collectionMoviesArray[indexPath.row].title
        cell.myImageView?.sd_setImage(with: URL(string: collectionMoviesArray[indexPath.row].image!), completed: nil)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVC_Obj : DetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "details") as! DetailsViewController
        
        detailsVC_Obj.selectedMovie = collectionMoviesArray[indexPath.row]
        self.navigationController?.pushViewController(detailsVC_Obj, animated: true )
    }
   
}
