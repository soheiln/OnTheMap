//
//  ViewController.swift
//  OnTheMap
//
//  Created by soheiln on 5/3/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        activityIndicator.color = UIColor.blueColor()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        clearFields()
    }

    
    // Called when login button is pressed. It will then try to get a Udacity session ID and handle any error if it fails
    @IBAction func loginButtonPressed() {
        let username = emailField.text!
        let password = passwordField.text!
        
        if username.isEmpty || password.isEmpty {
            showAlret("Username or Password is empty. Please enter both.")
        } else {
            setUIEnabled(false)

            UdacityClient.getUdacitySession(callerViewController: self, username: username, password: password, completionHandler: {

                performUIUpdatesOnMain {
                    self.loadMapViewWithData(Model.getInstance().udacitySessionID!, accountKey: Model.getInstance().udacityAccountKey!)
                }
                
                UdacityClient.getPublicUserData(Model.getInstance().udacityAccountKey!, errorHandler: nil)
            })
            
        }
    }
    
    
    // This method takes Udacity sessionID and accountKey as arguments and loads
    // the map view with data
    func loadMapViewWithData(sessionID: String, accountKey: String) {
        ParseClient.getStudentLocations(callerViewController: self, errorHandler: {
                print($2!.localizedDescription)
            }, completionHandler: { (studentLocations) in
                Model.getInstance().studentLocations = studentLocations
                performUIUpdatesOnMain {
                    let tabBarVC = self.storyboard?.instantiateViewControllerWithIdentifier("UITabBarController") as! UITabBarController
                    self.clearFields()
                    self.setUIEnabled(true)
                    self.presentViewController(tabBarVC, animated: true, completion: nil)
                }
        })
    }
    
    // method that gets called when sign up button is pressed which takes the user to Udacity's sign up page
    @IBAction func signupButtonPressed() {
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: Constants.Udacity.signupURL)!)
    }

}


extension LoginViewController {
    // MARK: Helper functions
    private func showAlret(message: String) {
        performUIUpdatesOnMain {
            let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(alertAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func setUIEnabled(enabled: Bool) {
        emailField.enabled = enabled
        passwordField.enabled = enabled
        loginButton.enabled = enabled
        
        // adjust login button alpha and activityIndicator
        if enabled {
            loginButton.alpha = 1.0
            activityIndicator.stopAnimating()
        } else {
            loginButton.alpha = 0.5
            activityIndicator.startAnimating()
        }
    }
    
    private func logError(string: String) {
        print(string)
    }
    
    // clears login fields
    func clearFields() {
        emailField.text = ""
        passwordField.text = ""
    }
    
}