//
//  DetailController.swift
//  GitHubClient
//
//  Created by Joshua Winskill on 10/21/14.
//  Copyright (c) 2014 Joshua Winskill. All rights reserved.
//

import UIKit

class DetailController: UIViewController {
    
    var networkController: NetworkController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
        
        if let value = NSUserDefaults.standardUserDefaults().valueForKey("OAuthToken") as NSString? {
            println(value)
        } else {
            self.networkController.requestOAuthAccess()
        }
    }

}
