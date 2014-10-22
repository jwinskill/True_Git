//
//  NetworkController.swift
//  GitHubClient
//
//  Created by Joshua Winskill on 10/20/14.
//  Copyright (c) 2014 Joshua Winskill. All rights reserved.
//

import UIKit

class NetworkController {
    
    let imageQueue = NSOperationQueue()
    let clientID = "client_id=ae9e888213acfa477b96"
    let clientSecret = "client_secret=8120c135124b289dd6b28dee6d1f66a79c803748"
    let gitHubOAuthURL = "https://github.com/login/oauth/authorize?"
    let scope = "scope=user,repo"
    let redirectURL = "redirect_uri=somefancyname://johnWayne"
    let gitHubPostURL = "https://github.com/login/oauth/access_token"
    var urlSession: NSURLSession?
    
    init () {
        self.imageQueue.maxConcurrentOperationCount = 6
    }
    
    func fetchRepos(searchTerm: String, completionHandler: (errorDescription: String?, repos: [Repository]?) -> Void) {
        
        let formattedSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        let url = NSURL(string: "https://api.github.com/search/repositories?q=\(formattedSearchTerm)")
        
        let value = NSUserDefaults.standardUserDefaults().valueForKey("OAuthToken") as NSString
        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = ["Authorization": "token \(value)"]
        self.urlSession = NSURLSession(configuration: configuration)
        
        println(NSUserDefaults.standardUserDefaults().valueForKey("OAuthToken") as NSString)
        
        
        let dataTask = self.urlSession!.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                println("Something bad happened")
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200...299:
                        println("She works, captain!")
                        for header in httpResponse.allHeaderFields {
                            //println(header)
                        }
                        let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
                        //println(responseString)
                        let repos = Repository.parseJSONIntoRepos(data)
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            completionHandler(errorDescription: nil, repos: repos)
                        })
                        
                    case 400...499:
                        println("this is the user's fault. Code: \(httpResponse)")
                    case 500...599:
                        println("This is the server's fault. Code: \(httpResponse)")
                    default:
                        println("Something else happened.")
                        
                    }
                }
            }
        })
        dataTask.resume()
    }
    
    func fetchUsers(searchTerm: String, completionHandler: (errorDescription: String?, users: [User]?) -> Void) {
        
        let formattedSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        let url = NSURL(string: "https://api.github.com/search/users?q=\(formattedSearchTerm)")
        
        let value = NSUserDefaults.standardUserDefaults().valueForKey("OAuthToken") as NSString
        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = ["Authorization": "token \(value)"]
        self.urlSession = NSURLSession(configuration: configuration)
        
        
        let dataTask = self.urlSession!.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                println("Something bad happened")
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200...299:
                        println("She works, captain!")
                        for header in httpResponse.allHeaderFields {
                            //println(header)
                        }
                        let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
                        //println(responseString)
                        let users = User.parseJsonIntoUsers(data)
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            completionHandler(errorDescription: nil, users: users)
                        })
                        
                    case 400...499:
                        println("this is the user's fault. Code: \(httpResponse)")
                    case 500...599:
                        println("This is the server's fault. Code: \(httpResponse)")
                    default:
                        println("Something else happened.")
                        
                    }
                }
            }
        })
        dataTask.resume()
    }
 
    func downloadAvatarForRepo(repo: Repository, completionHandler: (image: UIImage) -> Void) {
        let url = NSURL(string: repo.avatarURL)
        println(repo.avatarURL)
        let imageData = NSData(contentsOfURL: url!)
        let avatarImage = UIImage(data: imageData!)
        repo.avatarImage = avatarImage
        
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            completionHandler(image: avatarImage!)
        }
    }
    
    func downloadAvatarForUser(user: User, completionHandler: (image: UIImage) -> Void) {
        let url = NSURL(string: user.avatarImageURL)
        println(user.avatarImageURL)
        let imageData = NSData(contentsOfURL: url!)
        let avatarImage = UIImage(data: imageData!)
        user.avatarImage = avatarImage
        
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            completionHandler(image: avatarImage!)
        }
    }
    
    func requestOAuthAccess() {
        let url = gitHubOAuthURL + clientID + "&" + redirectURL + "&" + scope
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }
    
    func handleOAuthURL(callbackURL: NSURL) {
        let query = callbackURL.query
        let components = query?.componentsSeparatedByString("=")
        let code = components?.last
        
        // Constructing the query string for the final POST call
        let urlQuery = clientID + "&" + clientSecret + "&" + "code=\(code!)"
        
        var request = NSMutableURLRequest(URL: NSURL(string: gitHubPostURL)!)
        request.HTTPMethod = "POST"
        var postData = urlQuery.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
        let length = postData!.length
        request.setValue("\(length)", forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = postData
        
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                println(error.description)
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200...299:
                        var tokenResponse = NSString(data: data, encoding: NSASCIIStringEncoding)
                        println(tokenResponse!)
                        // create a NSURLSessionConfiguration
                        var comps = tokenResponse!.componentsSeparatedByString("&").first as NSString
                        comps = comps.componentsSeparatedByString("access_token=").last as NSString
                        
                        // Set user default for authorization key
                        NSUserDefaults.standardUserDefaults().setValue(comps, forKey: "OAuthToken")
                        NSUserDefaults.standardUserDefaults().synchronize()
                  
                    default:
                        println("Something bad happened")
                    }
                }
            }
        })
        dataTask.resume()
    }
}
