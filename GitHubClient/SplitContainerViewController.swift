//
//  SplitContainerViewController.swift
//  GitHubClient
//
//  Created by Joshua Winskill on 10/20/14.
//  Copyright (c) 2014 Joshua Winskill. All rights reserved.
//

import UIKit

class SplitContainerViewController: UIViewController, UISplitViewControllerDelegate {

    var repos: [Repository]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let splitVC = self.childViewControllers[0] as UISplitViewController
        splitVC.delegate = self

    }

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
        return true
    }

}
