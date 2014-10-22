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