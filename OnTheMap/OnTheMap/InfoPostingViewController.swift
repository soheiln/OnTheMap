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
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func mapButtonPressed(sender: AnyObject) {
        let address = textField.text!
        if address == "" {
            UIUtilities.showAlret(callerViewController: vc, message: "Address field empty. Please enter an address.")
        } else {
            UIUtilities.openInfoSubmitVCWithAddress(callerViewController: vc, address: address)
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
}

