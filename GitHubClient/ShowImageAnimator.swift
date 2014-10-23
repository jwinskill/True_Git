//
//  ShowImageAnimator.swift
//  GitHubClient
//
//  Created by Joshua Winskill on 10/22/14.
//  Copyright (c) 2014 Joshua Winskill. All rights reserved.
//

import UIKit

class ShowImageAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var origin: CGRect?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 1.0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as UsersCollectionViewController
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as ImageViewController
        
        let containerView = transitionContext.containerView()
        
        toViewController.view.frame = self.origin!
        toViewController.imageView.frame = toViewController.view.bounds
        
        containerView.addSubview(toViewController.view)
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            toViewController.view.frame = fromViewController.view.frame
            toViewController.imageView.frame = fromViewController.view.bounds
        }) { (finished) -> Void in
            fromViewController.view.alpha = 0.0
            transitionContext.completeTransition(finished)
        }
        
    }
    
}