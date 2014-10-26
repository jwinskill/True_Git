//
//  User.swift
//  GitHubClient
//
//  Created by Joshua Winskill on 10/22/14.
//  Copyright (c) 2014 Joshua Winskill. All rights reserved.
//

import UIKit

class User {
    var avatarImageURL: String
    var avatarImage: UIImage?
    var userName: String
    
    init (userName: String, avatarImageURL: String) {
        self.avatarImageURL = avatarImageURL
        self.userName = userName
    }
    
    class func parseJsonIntoUsers(rawJSONData: NSData) -> [User]? {
        var userArray = [User]()
        
        var error: NSError?

        if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: &error) as? NSDictionary {
            if let itemsArray = jsonDictionary["items"] as? NSArray {
                for object in itemsArray {
                    if let item = object as? NSDictionary {
                        let userName = item["login"] as NSString
                        let avatarImageURL = item["avatar_url"] as NSString
                        var newUser = User(userName: userName, avatarImageURL: avatarImageURL)
                        userArray.append(newUser)
                    }
                }
            }
            return userArray
        }
        return nil
    }
    
}

class AuthenticatedUser: User {
    var hirable: Bool
    var bio: String?
    var publicRepoCount: Int
    var privateRepoCount: Int
    
    init(userName: String, avatarImageURL: String, hirable: Bool, publicRepoCount: Int, privateRepoCount: Int, bio: String) {
        
        self.hirable = hirable
        self.bio = bio
        self.publicRepoCount = publicRepoCount
        self.privateRepoCount = privateRepoCount
        
        super.init(userName: userName, avatarImageURL: avatarImageURL)
    }
    
    class func parseJsonIntoAuthenticatedUser(rawData: NSData) -> AuthenticatedUser? {
        
        var error: NSError?
        
        if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(rawData, options: nil, error: &error) as? NSDictionary {
            var hirable = jsonDictionary["hireable"] as? Bool
            var bio = jsonDictionary["bio"] as? String
            var publicRepoCount = jsonDictionary["public_repos"] as? Int
            var userName = jsonDictionary["login"] as? String
            var avatarURL = jsonDictionary["avatar_url"] as? String
            if let plan = jsonDictionary["plan"] as? NSDictionary {
                var privateRepoCount = plan["private_repos"] as? Int
                if bio != nil {
                    var authenticatedUser = AuthenticatedUser(userName: userName!, avatarImageURL: avatarURL!, hirable: hirable!, publicRepoCount: publicRepoCount!, privateRepoCount: privateRepoCount!, bio: bio!)
                    return authenticatedUser
                } else {
                    var authenticatedUser = AuthenticatedUser(userName: userName!, avatarImageURL: avatarURL!, hirable: hirable!, publicRepoCount: publicRepoCount!, privateRepoCount: privateRepoCount!, bio: "bio not available")
                    return authenticatedUser
                }
                
            }
        }
        return nil
    }
    
}