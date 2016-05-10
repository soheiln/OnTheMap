//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by soheiln on 5/4/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import Foundation

struct StudentLocation {
    var firstName: String?
    var lastName: String?
    var createdAt: String?
    var updatedAt: String?
    var mapString: String?
    var mediaURL: String?
    var objectID: String?
    var uniqueKey: String?
    var latitute: Double?
    var longitude: Double?
    
    init() {
        firstName = ""
        lastName = ""
        createdAt = ""
        updatedAt = ""
        mapString = ""
        mediaURL = ""
        objectID = ""
        uniqueKey = ""
        latitute = 0.0
        longitude = 0.0
    }
    
    init(dictionary: [String : AnyObject]) {
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
        createdAt = dictionary["createdAt"] as! String
        updatedAt = dictionary["updatedAt"] as! String
        mapString = dictionary["mapString"] as! String
        mediaURL = dictionary["mediaURL"] as! String
        objectID = dictionary["objectID"] as! String
        uniqueKey = dictionary["uniqueKey"] as! String
        latitute = dictionary["latitute"] as! Double
        longitude = dictionary["longitude"] as! Double
    }

}
