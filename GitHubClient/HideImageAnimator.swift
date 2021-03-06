//
//  HideImageAnimator.swift
//  GitHubClient
//
//  Created by Joshua Winskill on 10/22/14.
//  Copyright (c) 2014 Joshua Winskill. All rights reserved.
//

import UIKit

class HideImageAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var origin: CGRect?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 1.0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as ImageViewController
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UsersCollectionViewController
        
        let containerView = transitionContext.containerView()
        containerView.insertSubview(toViewController.view, aboveSubview: fromViewController.view)
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: nil, animations: { () -> Void in
            fromViewController.view.frame = self.origin!
            fromViewController.imageView.frame = fromViewController.view.bounds
            toViewController.view.alpha = 1.0

        }) { (finished) -> Void in
            transitionContext.completeTransition(finished)
        }
        
    }
}