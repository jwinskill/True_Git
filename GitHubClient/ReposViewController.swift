//
//  UsersViewController.swift
//  GitHubClient
//
//  Created by Joshua Winskill on 10/20/14.
//  Copyright (c) 2014 Joshua Winskill. All rights reserved.
//

import UIKit

class ReposViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
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
        
        let repo = self.repos?[indexPath.row]
        if repo != nil {
            cell.userNameLabel.text = repo!.login
            cell.repoNameLabel.text = repo!.name
            if repo!.avatarImage? != nil {
                cell.avatarImageView?.image = repo!.avatarImage!
            } else {
                self.networkController.downloadAvatarForRepo(repo!, completionHandler: { (image) -> Void in
                    let cellForImage = self.tableView.cellForRowAtIndexPath(indexPath) as SearchResultCell
                    cellForImage.avatarImageView.image = image
                    self.tableView.reloadData()
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
    
}
