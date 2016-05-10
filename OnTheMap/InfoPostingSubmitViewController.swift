//
//  InfoPostingSubmitViewController.swift
//  OnTheMap
//
//  Created by soheiln on 5/3/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import UIKit
import MapKit

class InfoPostingSubmitViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    var placeMarks: [CLPlacemark]!
    var appDelegate: AppDelegate!
    var infoPostingVC: InfoPostingViewController!
    var vc: InfoPostingSubmitViewController!
    var address: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        loadLocationOnMap()
        textField.text = "Enter URL ..."
        textField.delegate = self
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        vc = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotification()
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadLocationOnMap() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = (placeMarks[0].location?.coordinate)!
        mapView.addAnnotation(annotation)
        mapView.centerCoordinate = annotation.coordinate
        let viewRegion = MKCoordinateRegionMakeWithDistance(annotation.coordinate, Constants.MapBound, Constants.MapBound)
        let adjustedRegion = mapView.regionThatFits(viewRegion)
        mapView.setRegion(adjustedRegion, animated: true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }

    @IBAction func submitButtonPressed(sender: AnyObject) {
        var sl = StudentLocation()
        sl.firstName = Model.getInstance().userFirstName
        sl.lastName = Model.getInstance().userLastName
        sl.mapString = address
        sl.mediaURL = textField.text
        sl.latitute = (placeMarks[0].location?.coordinate)!.latitude
        sl.longitude = (placeMarks[0].location?.coordinate)!.longitude
        ParseClient.postStudentLocation(callerViewController: self, studentLocation: sl, errorHandler: { data,response, error in
                print("Error in posting student location")
            }, completionHandler: {
                performUIUpdatesOnMain {
                    // dismiss infoPosting and infoPostingSubmit VCs
                    self.dismissViewControllerAnimated(false, completion: nil)
                    self.infoPostingVC.dismissViewControllerAnimated(false, completion: nil)

                    // present MapViewVC
                    let tabBarVC = self.storyboard?.instantiateViewControllerWithIdentifier("UITabBarController") as! UITabBarController
                    self.presentViewController(tabBarVC, animated: true, completion: nil)

                    
                }
                
        })
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: Keyboard Notification Subscription
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    
    func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y = getKeyboardHeight(notification) * -1
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }

}

