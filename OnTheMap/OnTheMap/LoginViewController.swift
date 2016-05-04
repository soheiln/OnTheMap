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
    
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }

    override func didReceiveMemoryWarning(  ) {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // Called when login button is pressed. It will then try to get a Udacity session ID and handle any error if it fails
    @IBAction func loginButtonPressed() {
        let username = emailField.text!
        let password = passwordField.text!
        
        if username.isEmpty || password.isEmpty {
            showAlret("Username or Password is empty. Please enter both.")
        } else {
            setUIEnabled(false)
            
            UdacityClient.getUdacitySession(username, password: password, completionHandler: { (data, response, error) in
                
                print("in getUdacitySession completion handler")
                print("response: \(response) \n\n\n")

                // handle error
                guard (error == nil) else {
                    self.showAlret("There was an error with login request: \(error)")
                    self.setUIEnabled(true)
                    return
                }
                
                // handle status code other than 2XX
                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                    self.showAlret("Login failed. Incorrect username or password")
                    self.setUIEnabled(true)
                    return
                }
                
                // handle empty data
                guard var data = data else {
                    self.showAlret("Login failed. (no response data from server)")
                    self.setUIEnabled(true)
                    return
                }
                
                // remove first 5 characters from response (subset response data)
                data = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                
                // parse data
                let parsedResult: AnyObject!
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                } catch {
                    self.showAlret("Login failed. (could not parse JSON response")
                    self.setUIEnabled(true)
                    return
                }
                
                // extract and store accountKey and sessionID
                let account = parsedResult["account"] as! [String: AnyObject]
                let session = parsedResult["session"] as! [String: AnyObject]
                let accountKey = account["key"] as! String
                let sessionID = session["id"] as! String
                self.appDelegate.udacityAccountKey = accountKey
                self.appDelegate.udacitySessionID = sessionID
                
                // enable UI
                self.setUIEnabled(true)
                self.loadMapViewWithData(self.appDelegate.udacitySessionID!, accountKey: self.appDelegate.udacityAccountKey!)
            })
            
        }
    }
    
    
    // This method takes Udacity sessionID and accountKey as arguments and loads
    // the map view with data
    func loadMapViewWithData(sessionID: String, accountKey: String) {
        print("in loadMapViewWithData")
                
        ParseClient.getStudentLocations({
                print("in getStudentLocations error handler")
                print($2!.localizedDescription)
            }, completionHandler: { (studentLocations) in
                print("in getStudentLocations completion handler")
                print(studentLocations)
            
        })
        
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

    private func setUIEnabled(enabled: Bool) {
        emailField.enabled = enabled
        passwordField.enabled = enabled
        loginButton.enabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
    private func logError(string: String) {
        print(string)
    }
    
    
    
    
    
    
    
    // method that gets student locations
    func getStudentLocations(errorHandler: (NSData?, NSURLResponse?, NSError?) -> Void, completionHandler: ([StudentLocation]) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: Constants.Parse.studentLocationMethod)!)
        request.addValue(Constants.Parse.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.Parse.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error_) in
            
            // handle error
            guard (error_ == nil) else {
                errorHandler(data, response, error_)
                return
            }
            
            // -- extract list of StudentLocation objects --
            
            // remove first 5 characters from response (subset response data)
            let data = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
            
            // parse data
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                errorHandler(data, response, error_)
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
}