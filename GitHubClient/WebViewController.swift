//
//  WebViewController.swift
//  GitHubClient
//
//  Created by Joshua Winskill on 10/23/14.
//  Copyright (c) 2014 Joshua Winskill. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    let webView = WKWebView()
    var urlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        

        if self.urlString != nil {
            self.webView.loadRequest(NSURLRequest(URL: NSURL(string: self.urlString!)!))
        }
    }
    
    override func loadView() {
        self.view = webView
    }


}
