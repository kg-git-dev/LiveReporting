//
//  EditProfileViewController.swift
//  Live_reporting
//
//  Created by LiveReporting on 11/7/15.
//  Copyright © 2015 LiveReporting. All rights reserved.
//

import UIKit
import Parse

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profilePIctureImageView: UIImageView!//cc
    //same will be used for camera @uttam
    
    let imagePicker: UIImagePickerController! = UIImagePickerController() //cc  created for camera @uttam
    
    @IBOutlet weak var firstNameTextField: UITextField!//cc
    
    @IBOutlet weak var lastNameTextField: UITextField!//cc
    
    @IBOutlet weak var passwordTextField: UITextField!//cc
    
    @IBOutlet weak var repeatPasswordTextField: UITextField!//cc
    
    var opener: LeftSideViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load user details
        let userFirstName = PFUser.currentUser()?.objectForKey("first_name") as! String
        let userLastName = PFUser.currentUser()?.objectForKey("last_name") as! String
        
        firstNameTextField.text = userFirstName
        lastNameTextField.text = userLastName
        
        let userImageFile = PFUser.currentUser()?.objectForKey("profile_picture") as! PFFile
        userImageFile.getDataInBackgroundWithBlock{(imageData:NSData?, error:NSError?) -> Void in
            if(imageData != nil)
            {
                self.profilePIctureImageView.image = UIImage(data: imageData!) //unwrapped image data from parse
                
                //making the profile picture circular
                self.profilePIctureImageView.layer.cornerRadius = self.profilePIctureImageView.frame.size.width/2
                self.profilePIctureImageView.clipsToBounds = true
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {//cc
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func chooseProfilePictureButtonTapped(sender: AnyObject) {//cc
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary // or camera
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func takePicture(sender: UIButton) { // access camera @utttam
        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .Camera
                imagePicker.cameraCaptureMode = .Photo
                presentViewController(imagePicker, animated: true, completion: {})
                imagePicker.delegate = self
            } else {
                postAlert("Rear camera doesn't exist", message: "Application cannot access the camera.")
            }
        } else {
            postAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
    }
    
   /* func imaagePickerController(imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject: AnyObject]) {
        
        var image = info[UIImagePickerControllerEditedImage] as? UIImage
        if image == nil {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
      
        
    }*/
    
    
    /*
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    print("Got an image")
    if let pickedImage:UIImage = (info[UIImagePickerControllerOriginalImage]) as? UIImage {
    let selectorToCall = Selector("imageWasSavedSuccessfully:didFinishSavingWithError:context:")
    UIImageWriteToSavedPhotosAlbum(pickedImage, self, selectorToCall, nil)
    }
    imagePicker.dismissViewControllerAnimated(true, completion: {
    // Anything you want to happen when the user saves an image
    })
    }
*/
    
    
    
    
    
    @IBAction func saveButonTapped(sender: AnyObject) {//cc
    //get current user
        let myUser:PFUser = PFUser.currentUser()!
        
        //get profile image data
        let profileImageData = UIImageJPEGRepresentation(profilePIctureImageView.image!, 1)
        
        //check if all fields are empty?
        let password = passwordTextField.text
        let FName = firstNameTextField.text
        let LName = lastNameTextField.text
        
        if(password!.isEmpty && FName!.isEmpty && LName!.isEmpty && (profileImageData == nil))
        {
            let myAlert = UIAlertController(title:"Alert", message:"All fields cannot be empty", preferredStyle:  UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil)
            
            myAlert.addAction(okAction)
            
            self.presentViewController(myAlert, animated: true, completion:nil)
            return
        }
        
        //if user decides to update their password we make sure there is no typo
        
        if(!password!.isEmpty && (password != repeatPasswordTextField.text)){
            let myAlert = UIAlertController(title:"Alert", message:"Passwords do not match", preferredStyle:  UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil)
            
            myAlert.addAction(okAction)
            
            self.presentViewController(myAlert, animated: true, completion:nil)
            return
        }
        
        //check if First name nad Last Name is not empty
        if(FName!.isEmpty || LName!.isEmpty )
        {
            let myAlert = UIAlertController(title:"Alert", message:"First Name and Last Name are both required", preferredStyle:  UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil)
            
            myAlert.addAction(okAction)
            
            self.presentViewController(myAlert, animated: true, completion:nil)
            return
        }
    
        //set new values for first name and last name
        myUser.setObject(FName!, forKey: "first_name")
        myUser.setObject(LName!, forKey: "last_name")
        
        //set new password
        if(!passwordTextField.text!.isEmpty){
         myUser.password = password
        }
        
        //set profile picture
        if(profileImageData != nil)
        {
            let profileFileObject = PFFile(data: profileImageData!)
            myUser.setObject(profileFileObject!, forKey: "profile_picture")
        }
        
        //MBProgress HUD
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.labelText = "Please wait"
        
        myUser.saveInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
         //hide activity indicator
            loadingNotification.hide(true)
            
            if(error != nil)
            {
                let myAlert = UIAlertController(title:"Alert", message: error!.localizedDescription, preferredStyle:  UIAlertControllerStyle.Alert)
                
                let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil)
                
                myAlert.addAction(okAction)
                
                self.presentViewController(myAlert, animated: true, completion:nil)
                return
            }
            
            if(success)
            {
                let userMessage = "Profile details successfully updated"
                let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle:  UIAlertControllerStyle.Alert)
                
                let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
                 
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                      self.opener.loadUserDetails() //opener object is of type leftsideviewcontroller and loaduserdetails is a custom function created there
                    })
                })
                myAlert.addAction(okAction)
                
                self.presentViewController(myAlert, animated: true, completion:nil)
                
            }
            
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        profilePIctureImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("User canceled image")
        dismissViewControllerAnimated(true, completion: {
            // Anything you want to happen when the user selects cancel
        })
    }
    func imageWasSavedSuccessfully(image: UIImage, didFinishSavingWithError error: NSError!, context: UnsafeMutablePointer<()>){
        print("Image saved")
        if let theError = error {
            print("An error happened while saving the image = \(theError)")
        } else {
            print("Displaying")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.profilePIctureImageView.image = image
            })
        }
    }
    
    
    func postAlert(title: String, message: String) { // for camaera @uttam
        let alert = UIAlertController(title: title, message: message,
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
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
