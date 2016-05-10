//
//  Model.swift
//  OnTheMap
//
//  Created by soheiln on 5/10/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import Foundation
import UIKit

class Model {
    // singleton instance
    static var instance: Model!
    
    // static variables
    var window: UIWindow?
    var udacitySessionID: String? = nil
    var udacityAccountKey: String? = nil
    var studentLocations: [StudentLocation]?
    var userFirstName: String?
    var userLastName: String?
    
    // empty constructor
    init() {
    }
    
    static func getInstance() -> Model {
        if instance == nil {
            instance = Model()
            return instance
        }
        return instance
    }
    
    
}