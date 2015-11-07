//
//  PasswordResetViewController.swift
//  Live_reporting
//
//  Created by LiveReporting on 11/6/15.
//  Copyright © 2015 LiveReporting. All rights reserved.
//

import UIKit
import Parse

class PasswordResetViewController: UIViewController {

    
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        let emailAddress = emailAddressTextField.text
        
        if(emailAddress!.isEmpty)
        {//display warming
            let myAlert = UIAlertController(title:"Alert", message:"Please enter your emaid id", preferredStyle:  UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil)
            
            myAlert.addAction(okAction)
            
            self.presentViewController(myAlert, animated: true, completion:nil)
        return
        }
        
        PFUser.requestPasswordResetForEmailInBackground(emailAddress!, block: {(success:Bool, error:NSError?) -> Void in
        if(error != nil)
        {
            //display error message
            let userMessage:String = error!.localizedDescription
            self.displayMessage(userMessage)
            }
        else{
            //display success message
            let userMessage:String = "An email has been sent to you at \(emailAddress)"
            self.displayMessage(userMessage)
            }
        
        })
        
        
    }
    
    func displayMessage(userMessage: String) //cc function for alert message
    {
        let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle:  UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.presentViewController(myAlert, animated: true, completion:nil)

    
    }

    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
