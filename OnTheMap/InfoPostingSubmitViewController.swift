//
//  InfoPostingSubmitViewController.swift
//  OnTheMap
//
//  Created by soheiln on 5/3/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import UIKit
import MapKit

class InfoPostingSubmitViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    var placeMark: [CLPlacemark]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        loadLocationOnMap()
    }
        
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadLocationOnMap() {
        var annotation = MKPointAnnotation()
        annotation.coordinate = (placeMark[0].location?.coordinate)!
        print("annotation coordinate: \(annotation.coordinate)")
        mapView.addAnnotation(annotation)
        mapView.centerCoordinate = annotation.coordinate
        var viewRegion = MKCoordinateRegionMakeWithDistance(annotation.coordinate, Constants.MapBound, Constants.MapBound)
        var adjustedRegion = mapView.regionThatFits(viewRegion)
        mapView.setRegion(adjustedRegion, animated: true)
    }
    
}

