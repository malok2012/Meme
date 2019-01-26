//
//  MemeSentTableViewController.swift
//  Meme2
//
//  Created by Malak Bassam on 11/27/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class MemeSentTableViewController: UITableViewController {
    var memes : [Meme]!{
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         tableView.reloadData()
        tabBarController?.tabBar.isHidden = false
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
         return self.memes.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meme = memes [(indexPath as NSIndexPath).row]
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "memeDetailViewController") as! MemoDetailsViewController
        detailController.meme = meme.memedImage
        self.navigationController!.pushViewController(detailController, animated: true)
        
        
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewMemeCell")!
        let meme = memes[indexPath.row].memedImage
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.image = meme
        cell.textLabel?.text = "\(memes[indexPath.row].topTextField) \(memes[indexPath.row].bottomTextField)"
        return cell
    }
    
    
    
}
