//
//  StringExtension.swift
//  GitHubClient
//
//  Created by Joshua Winskill on 10/23/14.
//  Copyright (c) 2014 Joshua Winskill. All rights reserved.
//

import Foundation

extension String {
    
    func validate() -> Bool {
        
        var error: NSError?
        let regex = NSRegularExpression(pattern: "[^0-9a-zA-Z\n]", options: nil, error: &error)
        
        if error != nil {
            println("Regex is invalid")
        } else {
            let match = regex?.numberOfMatchesInString(self, options: nil, range: NSRange(location: 0, length: countElements(self)))
            if match > 0 {
                return false
            }
        }
        return true
    }
}