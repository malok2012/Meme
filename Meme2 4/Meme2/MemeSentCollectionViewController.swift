//
//  MemeSentCollectionViewController.swift
//  Meme2
//
//  Created by Malak Bassam on 11/27/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit


class MemeSentCollectionViewController: UICollectionViewController {
@IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var memes : [Meme]!{
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)

       
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView!.reloadData()
        self.tabBarController?.tabBar.isHidden = false
    }
    // MARK: UICollectionViewDataSource



    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return  memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCell", for: indexPath) as! MemeSentCollectionViewCell
        cell.memeImageView.contentMode = .scaleAspectFit
        cell.memeImageView.image = memes[indexPath.row].memedImage
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "memeDetailViewController") as! MemoDetailsViewController
        detailVC.meme = memes[indexPath.row].memedImage
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
