//
//  MemoDetailsViewController.swift
//  Meme2
//
//  Created by Malak Bassam on 11/27/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class MemoDetailsViewController: UIViewController {
    var meme: UIImage?

    @IBOutlet var memeImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        memeImage.contentMode = .scaleAspectFit
        memeImage.image = meme
        // Do any additional setup after loading the view.
    }
    
}
