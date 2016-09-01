//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class GithubAPIClient {
    
    class func getRepositoriesWithCompletion(completion: (NSArray) -> ())
    {
       let urlString = "\(githubAPIURL)/repositories?client_id=\(githubClientID)&client_secret=\(githubClientSecret)"
        
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        
        let task = session.dataTaskWithURL(unwrappedURL) { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseArray = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray
            {
                if let responseArray = responseArray
                {
                    completion(responseArray)
                }
            }
        }
        task.resume()
    }
    
    class func checkIfRepositoryIsStarred(fullName:String, completion: (Bool) -> ())
    {
        let urlString = "https://api.github.com/user/starred/\(fullName)"
        
        let url = NSURL(string: urlString)
        
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        
        let request = NSMutableURLRequest(URL: unwrappedURL)
        request.HTTPMethod = "GET"
        request.addValue("\(token)", forHTTPHeaderField: "Authorization")
        
        let dataTask = session.dataTaskWithRequest(request) { data, response, error in
            
            guard let responseValue = response as? NSHTTPURLResponse else
            {
                assertionFailure("Response didn't work")
                return
            }
            
            if responseValue.statusCode == 204
            {
                print("Before: Starred")
                completion(true)
            }
            else if responseValue.statusCode == 404
            {
                print("Before: Unstarred")
                completion(false)
            }
            else
            {
                print("Other response value: \(responseValue.statusCode)")
            }
            
        }
        dataTask.resume()
    }
    
    class func starRepository(fullName: String, completion: ()->())
    {
        
        let urlString = "https://api.github.com/user/starred/\(fullName)"
        
        let url = NSURL(string: urlString)
        
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        
        let request = NSMutableURLRequest(URL: unwrappedURL)
        request.HTTPMethod = "PUT"
        request.addValue("\(token)", forHTTPHeaderField: "Authorization")
        
        let dataTask = session.dataTaskWithRequest(request) { data, response, error in
            
            guard let responseValue = response as? NSHTTPURLResponse else
            {
                assertionFailure("Response didn't work")
                return
            }
            
            if responseValue.statusCode == 204
            {
                print("After: Starred")
                completion()
            }
            else
            {
                print("Other response value: \(responseValue.statusCode), something went wrong")
            }
            
            
        }
        dataTask.resume()
        
    }
    
    class func unstarRepository(fullName: String, completion:() -> ())
    {
        let urlString = "https://api.github.com/user/starred/\(fullName)"
        
        let url = NSURL(string: urlString)
        
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        
        let request = NSMutableURLRequest(URL: unwrappedURL)
        request.HTTPMethod = "DELETE"
        request.addValue("\(token)", forHTTPHeaderField: "Authorization")
        
        let dataTask = session.dataTaskWithRequest(request) { data, response, error in
            
            guard let responseValue = response as? NSHTTPURLResponse else
            {
                assertionFailure("Response didn't work")
                return
            }
            
            if responseValue.statusCode == 204
            {
                print("After: Unstarred")
                completion()
            }
            else
            {
                print("Other response value: \(responseValue.statusCode), something went wrong")
            }
            
            
        }
        dataTask.resume()

    }
}

