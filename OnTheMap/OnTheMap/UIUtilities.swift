//
//  UIUtilities.swift
//  OnTheMap
//
//  Created by soheiln on 5/6/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class UIUtilities {
    
    static func openInfoSubmitVCWithAddress(callerViewController vc: UIViewController, address: String) {
        print("in openInfoSubmitVCWithAddress")
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: { (placeMark, error) in
            
            guard let placeMark = placeMark else {
                // handle error
                performUIUpdatesOnMain {
                    let alert = UIAlertController(title: "", message: "Could not find location on map. Please re-enter address.", preferredStyle: UIAlertControllerStyle.Alert)
                    let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    alert.addAction(alertAction)
                    vc.presentViewController(alert, animated: true, completion: nil)
                }
                return
            }
            
            // placeMark available
            performUIUpdatesOnMain {
                let infoSubmitVC = vc.storyboard?.instantiateViewControllerWithIdentifier("InfoPostingSubmitViewController") as! InfoPostingSubmitViewController
                infoSubmitVC.placeMark = placeMark
                vc.presentViewController(infoSubmitVC, animated: true, completion: nil)
            }
            
        })
        
    }
    
    
    static func showAlret(callerViewController vc: UIViewController, message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(alertAction)
        vc.presentViewController(alert, animated: true, completion: nil)
    }

}