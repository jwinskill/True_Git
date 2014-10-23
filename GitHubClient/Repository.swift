//
//  Repository.swift
//  GitHubClient
//
//  Created by Joshua Winskill on 10/20/14.
//  Copyright (c) 2014 Joshua Winskill. All rights reserved.
//

import UIKit

class Repository {
    
   // var totalCount: Int
    var name: String
    var fullName: String
    var avatarURL: String
    var repoURL: String
    var login: String
    var avatarImage: UIImage?
    
    init(name: String, fullName: String, avatarURL: String, login: String, repoURL: String) {
        // self.totalCount = totalCount
        self.name = name
        self.fullName = fullName
        self.avatarURL = avatarURL
        self.login = login
        self.repoURL = repoURL
    }
    
    class func parseJSONIntoRepos(rawJSONData: NSData) -> [Repository]? {
        
        var error: NSError?
        
        var repos = [Repository]()
    
        if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: &error) as? NSDictionary {

              // var totalCount = jsonDictionary["total_count"] as Int
            
                if let itemsArray = jsonDictionary["items"] as? NSArray {
                    for object in itemsArray {
                        if let item = object as? NSDictionary {
                            let name = item["name"] as String
                            let repoURL = item["html_url"] as String
                            let fullName = item["full_name"] as String
                            if let ownerDictionary = item["owner"] as? NSDictionary {
                                let avatarURL = ownerDictionary["avatar_url"] as String
                                let login = ownerDictionary["login"] as String
                                var newRepo = Repository(name: name, fullName: fullName, avatarURL: avatarURL, login: login, repoURL: repoURL)
                                repos.append(newRepo)
                            }
                        }
                    }

            }
            return repos
        }
        return nil
    }
}