//
//  SignUpViewController.swift
//  Live_reporting
//
//  Created by LiveReporting on 10/30/15.
//  Copyright © 2015 LiveReporting. All rights reserved.
//
import Parse
import Bolts
import UIKit

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate { //Uiimagepickercontrollerdelegate and uinavigationcontrollerdelegates were added to control image picking and navigation control action

    @IBOutlet weak var profilePhotoImageView: UIImageView! //custom created(CC)
    @IBOutlet weak var userEmailAddressTextField: UITextField! //CC
    @IBOutlet weak var userPasswordTextField: UITextField! //CC
    @IBOutlet weak var userPasswordRepeatTextField: UITextField! //CC
    @IBOutlet weak var userFirstNameTextField: UITextField! //CC
    @IBOutlet weak var userLastNameTextField: UITextField! //CC
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        self.edgesForExtendedLayout = UIRectEdge()
    }
    
    @IBAction func selectProfilePhotoButtonTapped(sender: AnyObject) {//CC
    let myPickerController = UIImagePickerController() //CC of type uiimagepickercontroller (previously var now let)
        myPickerController.delegate = self //selecting self as controller
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary //source of photo selected as photolibrary, can use camera instead of photolibrary
        self.presentViewController(myPickerController, animated: true, completion: nil) //initiating the controller
        
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
    profilePhotoImageView.image = info[UIImagePickerControllerOriginalImage] as?UIImage //here info is send as the pictue which is just set to profilephotoimageview
        self.dismissViewControllerAnimated(true, completion: nil) //exiting the controller
    
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) { //CC cancel button
    self.dismissViewControllerAnimated(true, completion: nil) //cancelling the sign up page over the sign in page
    }
    
    @IBAction func signUpButtonTapped(sender: AnyObject) {//CC
        let userName = userEmailAddressTextField.text  //cc
        let userPassword = userPasswordTextField.text //cc
        let userPasswordRepeat = userPasswordRepeatTextField.text //cc
        let userFirstName = userFirstNameTextField.text //cc
        let userLastName = userLastNameTextField.text //cc
        
        if (userName!.isEmpty || userPassword!.isEmpty || userPasswordRepeat!.isEmpty || userFirstName!.isEmpty || userLastName!.isEmpty) {//new change in xcode needs ! to wrap the string
        //var myAlert = UIAlertController(title: "Alert", message: "All Fields must be filled in", preferredStyle:UIAlertControllerStyle.Alert)
        
        let myAlert = UIAlertController(title: "Alert", message: "All fields must be filled in", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil)
        
        myAlert.addAction(okAction) //button added to message pop up
        
        //self.presentedViewController(myAlert, animated: true, completion: nil)
        self.presentViewController(myAlert, animated: true, completion: nil)
        
        return
        }
        if (userPassword != userPasswordRepeat){
        
            let myAlert = UIAlertController(title: "Alert", message: "Password Mismatch, please type again", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil)
            
            myAlert.addAction(okAction) //button added to message pop up
            
            //self.presentedViewController(myAlert, animated: true, completion: nil)
            self.presentViewController(myAlert, animated: true, completion: nil)
            return
        }
        
        
        let myUser:PFUser = PFUser() //cc of type pfuser, it has some default attributes ready
        myUser.username = userName
        myUser.password = userPassword
        myUser.email = userName
        myUser.setObject(userFirstName!, forKey: "first_name")//cc //note: now strings must be wrapped with ! mark
        myUser.setObject(userLastName!, forKey: "last_name")//cc
        
        //var profileImageData: UIImage
        if(profilePhotoImageView.image == nil){
            let myAlert = UIAlertController(title: "Alert", message: "Please choose profile pciture", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil)
            
            myAlert.addAction(okAction) //button added to message pop up
            
            //self.presentedViewController(myAlert, animated: true, completion: nil)
            self.presentViewController(myAlert, animated: true, completion: nil)
            return
        }
        
        let profileImageData = UIImageJPEGRepresentation(profilePhotoImageView.image!, 1)
        
        
        if(profileImageData != nil)
        {
            //create PFFile to send to parse
            let profileImageFile = PFFile (data:profileImageData!)
            myUser.setObject(profileImageFile!, forKey:"profile_picture")
        }
        else{
            let myAlert = UIAlertController(title: "Alert", message: "Please choose profile pciture", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil)
            
            myAlert.addAction(okAction) //button added to message pop up
            
            //self.presentedViewController(myAlert, animated: true, completion: nil)
            self.presentViewController(myAlert, animated: true, completion: nil)
            return

        }
        
        
        let spinningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true) //initializing HUD //cc
        spinningActivity.labelText = "Sending"
        spinningActivity.detailsLabelText = "Please wait"
        //spinningActivity.userInteractionEnabled = false //disables the user activity while HUD is active
        
        
        myUser.signUpInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            var userMessage = "Registration is successful"
         
            spinningActivity.hide(true) //hide activity indicator HUD
            
            
        if(!success){
            //userMessage="Couldn't register this time, please try again later"
            userMessage = error!.localizedDescription
        }
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){ action in
                if(success)
                {
                self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        myAlert.addAction(okAction) //button added to message pop up
        
        self.presentViewController(myAlert, animated: true, completion: nil)
        }

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
