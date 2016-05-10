//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by soheiln on 5/4/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import Foundation
import UIKit

class UdacityClient {
    
    // Method that gets a udacity session
    static func getUdacitySession(callerViewController vc: UIViewController,
            username: String, password: String,
            completionHandler: () -> Void) {
                
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error_ in
            
            // handle error
            guard (error_ == nil) else {
                UIUtilities.showAlret(callerViewController: vc, message: "There was an error with login request: \(error_)")
                (vc as! LoginViewController).setUIEnabled(true)
                return
            }
            
            // handle status code other than 2XX
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                UIUtilities.showAlret(callerViewController: vc, message: "Login failed. Incorrect username or password.")
                (vc as! LoginViewController).setUIEnabled(true)
                return
            }
            
            // handle empty data
            guard var data = data else {
                UIUtilities.showAlret(callerViewController: vc, message: "Login failed. (no response data from server)")
                (vc as! LoginViewController).setUIEnabled(true)
                return
            }
            
            // -- Request succeeded, proceed to parse data --
            
            // remove first 5 characters from response (subset response data)
            data = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            // parse data
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                UIUtilities.showAlret(callerViewController: vc, message: "Login failed. (could not parse JSON response")
                (vc as! LoginViewController).setUIEnabled(true)
                return
            }
            
            // extract and store accountKey and sessionID
            let account = parsedResult["account"] as! [String: AnyObject]
            let session = parsedResult["session"] as! [String: AnyObject]
            let accountKey = account["key"] as! String
            let sessionID = session["id"] as! String
            Model.getInstance().udacityAccountKey = accountKey
            Model.getInstance().udacitySessionID = sessionID

            
            // success, call completion handler on Main thread
            completionHandler()
            
        }
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
    static func getPublicUserData(accountKey: String,
            errorHandler: ((NSError?) -> Void)? ) {
                
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
            
            // extract user's first and last name and store it in Model
            let result = (parsedResult["user"]!) as! [String: AnyObject]
            Model.getInstance().userFirstName = result["first_name"] as! String
            Model.getInstance().userLastName = result["last_name"] as! String
            print("User name extracted: \(Model.getInstance().userFirstName!) \(Model.getInstance().userLastName!)")
            
        })
        task.resume()
    }
    
}