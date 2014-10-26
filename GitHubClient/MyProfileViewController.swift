//
//  MyProfileViewController.swift
//  GitHubClient
//
//  Created by Joshua Winskill on 10/24/14.
//  Copyright (c) 2014 Joshua Winskill. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController {
    
    var networkController: NetworkController!
    var authenticatedUser: AuthenticatedUser?

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var hirableLabel: UILabel!
    @IBOutlet weak var publicReposLabel: UILabel!
    @IBOutlet weak var privateReposLabel: UILabel!
    @IBOutlet weak var stripeView: UIView!
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
        
        // add in a loading indicator
        var ac = UIActivityIndicatorView()
        ac.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        ac.center = self.stripeView.center
        ac.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(ac)
        ac.startAnimating()
        
        // grab info from authenticated user to update labels/make network call
        if self.authenticatedUser != nil {
            self.userNameLabel.text = self.authenticatedUser!.userName
            if self.authenticatedUser!.hirable == true {
                self.hirableLabel.text = "Yes"
            } else {
                self.hirableLabel.text = "No"
            }
            self.publicReposLabel.text = "\(self.authenticatedUser!.publicRepoCount)"
            self.privateReposLabel.text = "\(self.authenticatedUser!.privateRepoCount)"
            self.networkController.downloadAvatarForUser(self.authenticatedUser!, completionHandler: { (image) -> Void in
                self.image.image = image
                println()
            })
        }
    }

}
