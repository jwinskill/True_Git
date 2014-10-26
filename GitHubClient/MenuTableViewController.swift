//
//  MenuTableViewController.swift
//  GitHubClient
//
//  Created by Joshua Winskill on 10/22/14.
//  Copyright (c) 2014 Joshua Winskill. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    var networkController: NetworkController!
    var authenticatedUser: AuthenticatedUser?

    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
        
        self.networkController.fetchAuthenticatedUser { (errorDescription, authenticatedUser) -> Void in
            
            if errorDescription != nil {
                println("Something bad happened")
            } else {
                self.authenticatedUser = authenticatedUser
                println(self.authenticatedUser?.userName)
            }
            
        }

        
        self.navigationController?.delegate = self
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let fromViewController = fromVC as? UsersCollectionViewController {
            if let toViewController = toVC as? ImageViewController {
                let animator = ShowImageAnimator()
                animator.origin = fromViewController.origin
                return animator
            }

        } else if let imageViewController = fromVC as? ImageViewController {
            let animator = HideImageAnimator()
            animator.origin = imageViewController.reverseOrigin
            
            return animator
        }
        return nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SHOW_PROFILE" {
            let destinationVC = segue.destinationViewController as MyProfileViewController
            if self.authenticatedUser != nil {
                destinationVC.authenticatedUser = self.authenticatedUser!
                
            }
        }
    }

}
