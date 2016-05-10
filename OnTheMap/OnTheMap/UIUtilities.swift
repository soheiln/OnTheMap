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
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: { (placeMarks, error) in
            
            guard let placeMarks = placeMarks else {
                // handle error
                performUIUpdatesOnMain {
                    let alert = UIAlertController(title: "", message: "Could not find location on map. Please re-enter address.", preferredStyle: UIAlertControllerStyle.Alert)
                    let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    alert.addAction(alertAction)
                    vc.presentViewController(alert, animated: true, completion: nil)
                }
                return
            }
            
            // placeMarks available
            performUIUpdatesOnMain {
                let infoSubmitVC = vc.storyboard?.instantiateViewControllerWithIdentifier("InfoPostingSubmitViewController") as! InfoPostingSubmitViewController
                infoSubmitVC.placeMarks = placeMarks
                infoSubmitVC.address = address
                infoSubmitVC.infoPostingVC = vc as! InfoPostingViewController
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

    
    // This method takes caller ViewController object as arguments and loads the MapViewVC and wait for the
    // getStudentLocation procedure to return before showing the pins on the map
    static func loadMapViewWithData(callerViewController vc: UIViewController) {
        // present mapView VC and wait for the data to
        let tabBarVC = vc.storyboard?.instantiateViewControllerWithIdentifier("UITabBarController") as! UITabBarController
        vc.presentViewController(tabBarVC, animated: true, completion: nil)

        
        //TODO: look up documentation and test this
//        let mapViewVC = tabBarVC.rootView!.rootView!
        let navigationVC = tabBarVC.selectedViewController! as! UINavigationController
        let mapViewVC = navigationVC.topViewController as! MapViewController
        //TODO: test above
        
        ParseClient.getStudentLocations(callerViewController: vc, errorHandler: {
            
            // handle error in getStudentLocations procedure call
            print($2!.localizedDescription)
            
            }, completionHandler: { (studentLocations) in
                
                // getStudentLocations returned successfully
                Model.getInstance().studentLocations = studentLocations
                
                performUIUpdatesOnMain {
                    // locations loaded, load pins on the map
                    mapViewVC.loadPins()
                }
        })
    }

}