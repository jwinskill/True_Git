//
//  ImageViewController.swift
//  GitHubClient
//
//  Created by Joshua Winskill on 10/22/14.
//  Copyright (c) 2014 Joshua Winskill. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    var reverseOrigin: CGRect?
    var image: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = self.image
        
    }

}
