//
//  ListViewController.swift
//  OnTheMap
//
//  Created by soheiln on 5/3/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var pinButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var appDelegate: AppDelegate!
    var pinImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        pinImage = UIImage(named: "pin")
        tableView.dataSource = self
        tableView.delegate = self
        hideActivityIndicator()
    }
    
    // MARK: TableView Delegate Implementation
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.getInstance().studentLocations!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell")!
        let sl = Model.getInstance().studentLocations![indexPath.row]
        cell.imageView?.image = pinImage
        cell.textLabel!.text = sl.firstName! + " " + sl.lastName!
        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if let url = Model.getInstance().studentLocations![indexPath.row].mediaURL {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: url)!)
        } else {
            //no URL available
            showAlret("No URL availabel for this student!")
        }
    }
    
    @IBAction func logoutButtonPressed() {
        showActivityIndicator()
        UdacityClient.deleteUdacitySession(callerViewController: self, errorHandler: {
            performUIUpdatesOnMain {
                self.hideActivityIndicator()
            }
            }, completionHandler: {
                performUIUpdatesOnMain {
                    Model.getInstance().udacitySessionID = ""
                    Model.getInstance().udacityAccountKey = ""
                    let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.presentViewController(loginVC, animated: true, completion: nil)
                }
        })
    }


}

extension ListViewController {
    // MARK: Helper functions
    private func showAlret(message: String) {
        performUIUpdatesOnMain {
            let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(alertAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    // shows the activity indicator over map. called from viewDidLoad
    func showActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    // hides the activity indicator from map. called when pins are loaded on map
    func hideActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
    }

}

