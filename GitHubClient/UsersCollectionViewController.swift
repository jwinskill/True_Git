//
//  UsersCollectionViewController.swift
//  GitHubClient
//
//  Created by Joshua Winskill on 10/22/14.
//  Copyright (c) 2014 Joshua Winskill. All rights reserved.
//

import UIKit

class UsersCollectionViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var usersCollectionView: UICollectionView!
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    var users: [User]?
    var networkController: NetworkController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
        

        self.usersCollectionView.dataSource = self
        self.searchBarOutlet.delegate = self
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if users != nil {
            return users!.count
        } else {
            return 0
        }

    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = usersCollectionView.dequeueReusableCellWithReuseIdentifier("USER_CELL", forIndexPath: indexPath) as UserCell
        var user = self.users?[indexPath.row]
        if user != nil {
            cell.userName.text = user!.userName
            if user!.avatarImage != nil {
                cell.imageView.image = user!.avatarImage!
            } else {
                self.networkController.downloadAvatarForUser(user!, completionHandler: { (image) -> Void in
                    let cellForImage = self.usersCollectionView.cellForItemAtIndexPath(indexPath) as UserCell
                    cellForImage.imageView.image = image
                    self.usersCollectionView.reloadData()
                })
            }
        }
        return cell
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        self.networkController.fetchUsers(searchBarOutlet.text, completionHandler: { (errorDescription, users) -> Void in
            
            if errorDescription != nil {
                println("something bad happened")
            } else {
                self.users = users
                if users != nil {
                    self.searchBarOutlet.resignFirstResponder()
                    self.usersCollectionView.reloadData()
                }
            }
        })
        
    }

    
    
}
