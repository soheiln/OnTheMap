//
//  ParseClient.swift
//  OnTheMap
//
//  Created by soheiln on 5/4/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import Foundation

class ParseClient {
    
    // method that gets student locations
    static func getStudentLocations(errorHandler: ((NSData?, NSURLResponse?, NSError?) -> Void)?, completionHandler: ([StudentLocation]) -> Void) {

        print("in getStudentLocations: error == nil")
        let request = NSMutableURLRequest(URL: NSURL(string: Constants.Parse.studentLocationMethod)!)
        request.addValue(Constants.Parse.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.Parse.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error_) in
            
            // handle error
            guard (error_ == nil) else {
                print("in getStudentLocations: error == nil")
                if let errorHandler = errorHandler {
                    errorHandler(data, response, error_)
                }
                return
            }
            
            // -- extract list of StudentLocation objects --
            
            // parse data
            let parsedResult: AnyObject!
            do {
                print("in getStudentLocations: do { parse data ...")
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            } catch {
                print("in getStudentLocations: in catch...")
                if let errorHandler = errorHandler {
                    errorHandler(data, response, error_)
                }
                return
            }
            
            // extract array of StudentLocation objects
            var studentLocations = [StudentLocation]()
            let results = parsedResult["results"] as! [[String: AnyObject]]
            for item in results {
                var sl = StudentLocation()
                sl.firstName = item["firstName"] as? String
                sl.lastName = item["lastName"] as? String
                sl.createdAt = item["createdAt"] as? String
                sl.updatedAt = item["updatedAt"] as? String
                sl.mapString = item["mapString"] as? String
                sl.mediaURL = item["mediaURL"] as? String
                sl.objectID = item["objectID"] as? String
                sl.uniqueKey = item["uniqueKey"] as? String
                sl.latitute = item["latitute"] as? Float
                sl.longitude = item["longitude"] as? Float
                studentLocations.append(sl)
            }
            completionHandler(studentLocations)
        }
        task.resume()
    }
    
    
    // method that posts a student location
    func postStudentLocation(completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
    }

}
