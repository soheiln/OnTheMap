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
}
