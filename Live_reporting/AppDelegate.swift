//
//  AppDelegate.swift
//  Live_reporting
//
//  Created by LiveReporting on 10/30/15.
//  Copyright © 2015 LiveReporting. All rights reserved.
//

import UIKit
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var drawerContainer: MMDrawerController?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
 
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("SqdF7FDxFxLaTiS2VSfZfo5U31w5rqrM2jh3YQfF",
            clientKey: "hICSYcPcP0pcV9rHNpXtVOvR5kXUqxxn65e7DcHl")
        
        let navigationAppeerance = UINavigationBar.appearance()
        let navBackgoundImage: UIImage! = UIImage(named: "topbar_background")
        navigationAppeerance.setBackgroundImage(navBackgoundImage, forBarMetrics: .Default)
        navigationAppeerance.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        
        buildUserInterface()
        
        
        
        
        
        // [Optional] Track statistics around application opens.
        //PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        //test code: creates an object in parse; search in core tab
        //let testObject = PFObject(className: "TestObject")
        //testObject["foo"] = "bar"
        //testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
          //  print("Object has been saved.")
        //}
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func buildUserInterface() //cc
    {
        
        
        let userName:String? = NSUserDefaults.standardUserDefaults().stringForKey("user_name")
        
        if(userName != nil){
            
            //Navigate to Protected page
            let mainStoryBoard:UIStoryboard = UIStoryboard (name:"Main", bundle:nil)
            
            //creating view controllers
            let mainPage : MainPageViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("MainPageViewController") as! MainPageViewController //instantiating a class  with storyboard id of main page view controller //cc
            
            let leftSideMenu : LeftSideViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("LeftSideViewController") as! LeftSideViewController //instantiating a class  with storyboard id of left side view controller //cc
            
            let righttSideMenu : RightSideViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("RightSideViewController") as! RightSideViewController //instantiating a class  with storyboard id of left side view controller //cc
            
            
            //Wrapping into navigation controllers
            let mainPageNav = UINavigationController(rootViewController: mainPage) //setting main page as root view controller to return back to sign in page after logout
            let leftSideMenuNav = UINavigationController(rootViewController: leftSideMenu)
            let rightSideMenuNav = UINavigationController(rootViewController: righttSideMenu)
            
            drawerContainer = MMDrawerController(centerViewController: mainPageNav, leftDrawerViewController: leftSideMenuNav, rightDrawerViewController: rightSideMenuNav)
            
            drawerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView
            drawerContainer?.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.PanningCenterView
            
           // let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
           // appDelegate.window?.rootViewController = mainPageNav
            window?.rootViewController = drawerContainer
        }
        
    }
    
    


}
