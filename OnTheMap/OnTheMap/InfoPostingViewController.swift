//
//  InfoPostingViewController.swift
//  OnTheMap
//
//  Created by soheiln on 5/3/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import UIKit


class InfoPostingViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var mapButton: UIButton!
    var vc: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vc = self
        textField.text = "Enter location ..."
        textField.delegate = self
    }
        
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        print("cancelButtonPressed")
//        dismissViewControllerAnimated(true, completion: nil)
    }

    
    @IBAction func mapButtonPressed(sender: AnyObject) {
        print("mapButtonPressed")
        var address = textField.text!
        if address == "" {
            print("address nil")
            UIUtilities.showAlret(callerViewController: vc, message: "Please enter an address")
        } else {
            print("address avail")
            UIUtilities.openInfoSubmitVCWithAddress(callerViewController: vc, address: address)
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
}

