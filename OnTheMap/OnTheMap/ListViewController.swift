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
    var appDelegate: AppDelegate!
    var pinImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in listVC view did load")
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        pinImage = UIImage(named: "pin")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: TableView Delegate Implementation
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("in tableView numRows: \(appDelegate.studentLocations!.count)")
        return appDelegate.studentLocations!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell")!
        let sl = appDelegate.studentLocations![indexPath.row]
        cell.imageView?.image = pinImage
        cell.textLabel!.text = sl.firstName! + " " + sl.lastName!
        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        print("in tableView didSelectRow: \(appDelegate.studentLocations![indexPath.row].mediaURL!)")
        if let url = appDelegate.studentLocations![indexPath.row].mediaURL {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: url)!)
        } else {
            //no URL available
            showAlret("No URL availabel for this student!")
        }
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

}

