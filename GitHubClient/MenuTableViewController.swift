//
//  MenuTableViewController.swift
//  GitHubClient
//
//  Created by Joshua Winskill on 10/22/14.
//  Copyright (c) 2014 Joshua Winskill. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

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

}
