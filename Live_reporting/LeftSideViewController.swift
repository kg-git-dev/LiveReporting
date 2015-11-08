//
//  LeftSideViewController.swift
//  Live_reporting
//
//  Created by LiveReporting on 10/31/15.
//  Copyright © 2015 LiveReporting. All rights reserved.
//

import UIKit
import Parse
import Bolts

class LeftSideViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var userFullNameLabel: UILabel!
    
    
    var menuItems:[String] = ["Main", "Profile", "Sign out"]//cc
   // var menuItems = [] //trying to get the image files inside the table row
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadUserDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @available(iOS 2.0, *)
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return menuItems.count
    }
   
    
    @available(iOS 2.0, *)
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let myCell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)//identifier is myCell for prototype Cells
        myCell.textLabel?.text = menuItems[indexPath.row]
        
        return myCell
    }
    //the function is taken from the uitableviewdelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        switch(indexPath.row)// this holds the cells in table view as numbers 0, 1, 2
        {
        case 0:
            //open main page
            let mainPageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainPageViewController") as! MainPageViewController
            
            let mainPageNav = UINavigationController(rootViewController:mainPageViewController)
            
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.drawerContainer!.centerViewController = mainPageNav
            
            appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
            break
        case 1:
            //open about page
            let aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutViewController") as! AboutViewController
            
            let aboutPageNav = UINavigationController(rootViewController:aboutViewController)
            
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.drawerContainer!.centerViewController = aboutPageNav
            
            appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
            break
        case 2:
            //perform sign out
            
            
            NSUserDefaults.standardUserDefaults().removeObjectForKey("user_name")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            let spinningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true) //initializing HUD //cc
            spinningActivity.labelText = "Sending"
            spinningActivity.detailsLabelText = "Please wait"
            //spinningActivity.userInteractionEnabled = false //disables the user activity while HUD is active
            
            PFUser.logOutInBackgroundWithBlock{(error:NSError?) -> Void in
            
                spinningActivity.hide(true)
                
            //navigating to protected page
                let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
                
                let signInPage:ViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
                
                let signInPageNav = UINavigationController(rootViewController:signInPage)
                
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                
                appDelegate.window?.rootViewController = signInPageNav
            
            }
            break
        default:
            print("how come?")
        }
    }

    @IBAction func editButtonTapped(sender: AnyObject) {//cc making the object inside edit profile view controller communicating with the leftside view controller
        let editProfile = self.storyboard?.instantiateViewControllerWithIdentifier("EditProfileViewController") as! EditProfileViewController
        editProfile.opener = self
        let editProfileNav = UINavigationController(rootViewController: editProfile)
        self.presentViewController(editProfileNav, animated: true, completion: nil)
    }
    
    func loadUserDetails() //cc
    {
        //getting username and password from the parse
        let userFirstName = PFUser.currentUser()?.objectForKey("first_name") as! String
        let userLastName = PFUser.currentUser()?.objectForKey("last_name") as! String
        userFullNameLabel.text = userFirstName + " " + userLastName
        
        let profilePictureObject = PFUser.currentUser()?.objectForKey("profile_picture") as! PFFile  
        profilePictureObject.getDataInBackgroundWithBlock{(imageData:NSData?, error:NSError?) -> Void in
            if(imageData != nil)
            {
                self.userProfilePicture.image = UIImage(data: imageData!) //unwrapped image data from parse
                
                //making the profile picture circular
                self.userProfilePicture.layer.cornerRadius = self.userProfilePicture.frame.size.width/2
                self.userProfilePicture.clipsToBounds = true
            }
            
        }

    }
    
}







