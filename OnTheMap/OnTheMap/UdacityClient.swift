//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by soheiln on 5/4/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import Foundation

class UdacityClient {
    
    // Method that gets Udacity Session ID using the username and password, and calls the provided completion handler
    static func getUdacitySession(username: String, password: String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: completionHandler)
        task.resume()
    }
    
    
    // Method that ends a Udacity session, i.e. logs out
    static func deleteUdacitySession(completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forKey: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: completionHandler)
        task.resume()
    }
    
    
    // Method that gets the public user data and stores user's first and last name in appDelegate
    static func getPublicUserData(accountKey: String, appDelegate: AppDelegate, errorHandler: ((NSError?) -> Void)? ) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(accountKey)")!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error in
            guard var data = data else {
                // handle error
                if let errorHandler = errorHandler {
                    errorHandler(error)
                }
                return
            }
            
            // remove first 5 characters from response (subset response data)
            data = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            // parse data
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                print("Error: \(error)")
                return
            }
            
            // extract user's first and last name and store it in appDelegate
            let result = (parsedResult["user"]!) as! [String: AnyObject]
            Model.getInstance().userFirstName = result["first_name"] as! String
            Model.getInstance().userLastName = result["last_name"] as! String
            print("User name extracted: \(Model.getInstance().userFirstName!) \(Model.getInstance().userLastName!)")
            
        })
        task.resume()
    }
    
}