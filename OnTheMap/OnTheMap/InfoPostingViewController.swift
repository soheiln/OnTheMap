//
//  InfoPostingViewController.swift
//  OnTheMap
//
//  Created by soheiln on 5/3/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import UIKit

class InfoPostingViewController: UIViewController {
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var mapButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

