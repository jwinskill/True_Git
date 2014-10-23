//
//  UsersCollectionViewController.swift
//  GitHubClient
//
//  Created by Joshua Winskill on 10/22/14.
//  Copyright (c) 2014 Joshua Winskill. All rights reserved.
//

import UIKit

class UsersCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var usersCollectionView: UICollectionView!
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    var users: [User]?
    var networkController: NetworkController!
    var origin: CGRect?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
        

        self.usersCollectionView.dataSource = self
        self.usersCollectionView.delegate = self
        self.searchBarOutlet.delegate = self
        
    }
    
    // MARK - UICollectionView DataSource methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if users != nil {
            return users!.count
        } else {
            return 0
        }

    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = usersCollectionView.dequeueReusableCellWithReuseIdentifier("USER_CELL", forIndexPath: indexPath) as UserCell
        
        cell.imageView.image = UIImage(named: "octocat")
        var currentTag = cell.tag + 1
        cell.tag = currentTag
        
        var user = self.users?[indexPath.row]
        if user != nil {
            cell.userName.text = user!.userName
            if user!.avatarImage != nil {
                cell.imageView.image = user!.avatarImage!
            } else {
                self.networkController.downloadAvatarForUser(user!, completionHandler: { (image) -> Void in
                    if cell.tag == currentTag {
                        cell.imageView.image = image
                    }
                })
            }
        }
        return cell
    }
    
    // MARK - UICollectionView Delegate methods
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let attributes = usersCollectionView.layoutAttributesForItemAtIndexPath(indexPath)
        
        let origin = self.view.convertRect(attributes!.frame, fromView: usersCollectionView)
        
        self.origin = origin
        
        if users != nil {
            let user = self.users![indexPath.row]
            let image = user.avatarImage
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyBoard.instantiateViewControllerWithIdentifier("IMAGE_VIEW_CONTROLLER") as ImageViewController
            viewController.image = image
            viewController.reverseOrigin = self.origin!
            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        
    }
    
    
    // MARK - UISearchBarDelegate methods
    
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
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        println(text)
        
        var warningRect = CGRect(x: 37, y: 114, width: 300, height: 40)
        var warningLabel = UILabel()
        warningLabel.frame = warningRect
        warningLabel.backgroundColor = UIColor.redColor()
        warningLabel.textColor = UIColor.whiteColor()
        warningLabel.textAlignment = NSTextAlignment.Center
        warningLabel.layer.cornerRadius = 8
        warningLabel.clipsToBounds = true
        warningLabel.alpha = 0
        warningLabel.text = "Search does not support character '\(text)'"
        
        
        if text.validate() == false {
            view.addSubview(warningLabel)
            UIView.animateWithDuration(0.8, delay: 0.0, options: nil, animations: { () -> Void in
                warningLabel.alpha = 1.0
                }, completion: { (finished) -> Void in
                    UIView.animateWithDuration(0.8, delay: 2.0, options: nil, animations: { () -> Void in
                        warningLabel.alpha = 0.0
                        }, completion: { (finished) -> Void in
                            //
                    })
            })
        }
        return text.validate()
    }
    
}
