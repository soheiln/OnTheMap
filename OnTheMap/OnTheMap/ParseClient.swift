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

        let request = NSMutableURLRequest(URL: NSURL(string: Constants.Parse.studentLocationMethod + Constants.Parse.studentLocationMethodParameters)!)
        request.addValue(Constants.Parse.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.Parse.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error_) in
            
            // handle error
            guard (error_ == nil) else {
                if let errorHandler = errorHandler {
                    errorHandler(data, response, error_)
                }
                return
            }
            
            // -- extract list of StudentLocation objects --
            
            // parse data
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            } catch {
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
                sl.latitute = item["latitude"] as? Double
                sl.longitude = item["longitude"] as? Double
                studentLocations.append(sl)
            }
            completionHandler(studentLocations)
        }
        task.resume()
    }
    
    
    // method that posts a student location
    static func postStudentLocation(studentLocation: StudentLocation, errorHandler: ((NSData?, NSURLResponse?, NSError?) -> Void)?, completionHandler: () -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue(Constants.Parse.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.Parse.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"\(studentLocation.firstName!)\", \"lastName\": \"\(studentLocation.lastName!)\",\"mapString\": \"\(studentLocation.mapString!)\", \"mediaURL\": \"\(studentLocation.mediaURL!)\",\"latitude\": \(studentLocation.latitute!), \"longitude\": \(studentLocation.longitude!)}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error_ in

            // handle error
            guard (error_ == nil) else {
                if let errorHandler = errorHandler {
                    errorHandler(data, response, error_)
                }
                return
            }
            
            // success, call completion handle
            completionHandler()
        }
        task.resume()
    }

}
