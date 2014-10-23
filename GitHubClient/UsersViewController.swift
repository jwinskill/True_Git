//
//  UsersViewController.swift
//  GitHubClient
//
//  Created by Joshua Winskill on 10/20/14.
//  Copyright (c) 2014 Joshua Winskill. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var networkController: NetworkController!
    var repos: [Repository]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.searchBarOutlet.delegate = self
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
        
        }
    
    // MARK: - UITableView DataSource methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if repos != nil {
            return self.repos!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SEARCH_CELL") as SearchResultCell
        
        cell.avatarImageView.image = UIImage(named: "octocat")
        var currentTag = cell.tag + 1
        cell.tag = currentTag
        
        let repo = self.repos?[indexPath.row]
        if repo != nil {
            cell.userNameLabel.text = repo!.login
            cell.repoNameLabel.text = repo!.name
            if repo!.avatarImage? != nil {
                cell.avatarImageView?.image = repo!.avatarImage!
            } else {
                self.networkController.downloadAvatarForRepo(repo!, completionHandler: { (image) -> Void in
        
                    if cell.tag == currentTag {
                        cell.avatarImageView.image = image
                    }
                })
            }
        }
        return cell
    }
    
    // MARK: - SearchBar Delegate methods
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        self.networkController.fetchRepos(searchBarOutlet.text, completionHandler: { (errorDescription, repos) -> Void in
            
            if errorDescription != nil {
                println("something bad happened")
            } else {
                self.repos = repos
                if repos != nil {
                    self.searchBarOutlet.resignFirstResponder()
                    self.tableView.reloadData()
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SEGUE_TO_WEBVIEW" {
            var destinationVC = segue.destinationViewController as WebViewController
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                if let repoToBePassed = self.repos?[indexPath.row] {
                    destinationVC.urlString = repoToBePassed.repoURL
                }
            }
        }
    }
    
}
