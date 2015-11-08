//
//  ViewController.swift
//  Live_reporting
//
//  Created by LiveReporting on 10/30/15.
//  Copyright © 2015 LiveReporting. All rights reserved.
//

import UIKit
import Parse
import Bolts
import FBSDKLoginKit
import ParseFacebookUtilsV4


class ViewController: UIViewController {

    @IBOutlet weak var userEmailAddressTextField: UITextField! //cc
    @IBOutlet weak var userPasswordTextField: UITextField!//cc
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var anonymousButton: UIButton!
    
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var loginBackgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func anonymousButtonTapped(sender: AnyObject) {
        let bgimage: UIImage! = UIImage(named: "black background")
        userEmailAddressTextField.hidden = false
        userPasswordTextField.hidden = false
        forgotPasswordButton.hidden = false
        signInButton.hidden = false
        anonymousButton.hidden = true
        facebookButton.hidden = true
        registerButton.hidden = true
        loginBackgroundImage.image = bgimage
        let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        
        let signInPage:ViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        
        let signInPageNav = UINavigationController(rootViewController:signInPage)
        
        signInPageNav.navigationBarHidden = false
        self.navigationController?.navigationBarHidden = false
        //UINavigationBar.appearance().hidden = false
        
    }
    
    
    @IBAction func signInButtonTapped(sender: AnyObject) {//cc
        let userEmail = userEmailAddressTextField.text
        let userPassword = userPasswordTextField.text
        
        if( userEmail!.isEmpty || userPassword!.isEmpty)
        {
            let myAlert = UIAlertController(title:"Alert", message:"Both username and password should be filled", preferredStyle:  UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil)
            
            myAlert.addAction(okAction)
            
            self.presentViewController(myAlert, animated: true, completion:nil)

        return
        }
        
        let spinningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true) //initializing HUD //cc
        spinningActivity.labelText = "Sending"
        spinningActivity.detailsLabelText = "Please wait"
        //spinningActivity.userInteractionEnabled = false //disables the user activity while HUD is active
        
        PFUser.logInWithUsernameInBackground(userEmail!, password: userPassword!) { (user:PFUser?, error:NSError?) -> Void in
        
        //spinningActivity.hide(true) // can be used as alternative to the code below
            dispatch_async(dispatch_get_main_queue()){
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
            
            
        var userMessage = "Welcome!"
        
        if(user != nil)
        {
            // Remembers the sign in state
            
            let userName : String? = user?.username
            NSUserDefaults.standardUserDefaults().setObject(userName, forKey:"user_name")// to check and remember deafult user login state
            NSUserDefaults.standardUserDefaults().synchronize() //synchronising with the consistent data
            
            //Navigate to Protected page
          //  let mainStoryBoard:UIStoryboard = UIStoryboard (name:"Main", bundle:nil)
           // let mainPage : MainPageViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("MainPageViewController") as! MainPageViewController //instantiating a class  with storyboard id of main page view controller //cc
            
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

           // let mainPageNav = UINavigationController(rootViewController: mainPage) //setting main page as root view controller to return back to sign in page after logout
            appDelegate.buildUserInterface() //this is a custom defined function inside appdelegate.swift
           // appDelegate.window?.rootViewController = mainPageNav
            
        }
        else
        {
        userMessage = error!.localizedDescription
            let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle:  UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil)
            
            myAlert.addAction(okAction)
            
            self.presentViewController(myAlert, animated: true, completion:nil)
            
            
            }
        
        }
    }
    
    @IBAction func facebookButtonTapped(sender: AnyObject) { //facebook login completion handler
        let permissions = ["public_profile","email"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: {(user: PFUser?, error: NSError?) -> Void in
        
            if(error != nil)
            {
                //display an error message
                
                let userMessage = error?.localizedDescription
                
                let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle:  UIAlertControllerStyle.Alert)
                
                let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil)
                
                myAlert.addAction(okAction)
                
                self.presentViewController(myAlert, animated: true, completion:nil)
                
                return

            }
            
            //load facebook details like user first name, last name, email id, profile picture
            self.loadFacebookDetails()
        
        })
        
    }
    
    func loadFacebookDetails()//cc
    {
        //show activity indicator
        let spinningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true) //initializing HUD //cc
        spinningActivity.labelText = "Loading"
        spinningActivity.detailsLabelText = "Please wait"

        //defining the fields we want to read from facebook user object
        let requestParameters = ["fields": "id, email, first_name, last_name, name"]
        
        let userDetails = FBSDKGraphRequest(graphPath: "me", parameters:  requestParameters)
        
        userDetails.startWithCompletionHandler({
            (connection, result, error:NSError!) -> Void in
            
            if error != nil {
                //display error message
                
                spinningActivity.hide(true)
                
                let userMessage = error?.localizedDescription
                
                let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle:  UIAlertControllerStyle.Alert)
                
                let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil)
                
                myAlert.addAction(okAction)
                
                self.presentViewController(myAlert, animated: true, completion:nil)
                
                PFUser.logOut() //logout if facebook login is unsuccessful
                
                return
                
            }
            
            //loading the data
            let userId:String = result["id"] as! String
          //  print("User id = \(userId)") //checking data
            // let userfullName:String = result["name"] as! String
             let userEmail:String? = result["email"] as? String
             let userFirstName:String? = result["first_name"] as? String
             let userLastName:String? = result["last_name"] as? String
            
            var userProfile = "https://graph.facebook.com/" + userId + "/picture?type=square"
            
            let profilePictureUrl = NSURL(string: userProfile)
            
            let profilePictureData = NSData(contentsOfURL: profilePictureUrl!)
            
            //prepare PFUser object
            if(profilePictureData != nil)
            {
                let profileFileObject = PFFile(data:profilePictureData!)
                PFUser.currentUser()?.setObject(profileFileObject!, forKey: "profile_picture")
            }
          
            PFUser.currentUser()?.setObject(userFirstName!, forKey: "first_name")
            PFUser.currentUser()?.setObject(userLastName!, forKey: "last_name")
            
            if let userEmail = userEmail
            {
            PFUser.currentUser()?.email = userEmail
            PFUser.currentUser()?.username = userEmail
            }
            
            
            PFUser.currentUser()?.saveInBackgroundWithBlock ({(success:Bool, error:NSError?) -> Void in
                
                spinningActivity.hide(true)
                if error != nil {
                    //display error message
                    
                    spinningActivity.hide(true)
                    
                    let userMessage = error?.localizedDescription
                    
                    let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle:  UIAlertControllerStyle.Alert)
                    
                    let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil)
                    
                    myAlert.addAction(okAction)
                    
                    self.presentViewController(myAlert, animated: true, completion:nil)
                    
                    PFUser.logOut() //logout if login is unsuccessful
                    
                    return
                    
                }
                
                if(success)
                {
                    if !userId.isEmpty
                    {
                        NSUserDefaults.standardUserDefaults().setObject(userId, forKey: "user_name")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
                        dispatch_async(dispatch_get_main_queue()){
                            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            appDelegate.buildUserInterface()
                        }
                    
                    }
                
                
                
                }
                
            })//*/
        
        })
    }
    
}


