//
//  MainPageViewController.swift
//  Live_reporting
//
//  Created by LiveReporting on 10/31/15.
//  Copyright © 2015 LiveReporting. All rights reserved.
//

import UIKit
import Parse
import AssetsLibrary
import MobileCoreServices

class MainPageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func leftSideButtonTapped(sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        print("tapped")
        appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
  
   
    @IBAction func takePicture(sender: UIBarButtonItem) {  // recordshere
        
        let imagePicker: UIImagePickerController! = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = .Camera
        
        if let availableTypes = UIImagePickerController.availableMediaTypesForSourceType(.Camera) {
            
            imagePicker.sourceType = .Camera
            
            if (availableTypes as NSArray).containsObject(kUTTypeMovie) {
                
                imagePicker.mediaTypes = [kUTTypeMovie as String]
                imagePicker.videoQuality = UIImagePickerControllerQualityType.TypeLow///4800p
                imagePicker.videoMaximumDuration = 30
                
                presentViewController(imagePicker, animated: true, completion: nil)
                
                
                
                
            }
            else {
                postAlert("Rear camera doesn't exist", message: "Application cannot access the camera.")
                
            }
            
        }
        else {
            postAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
        
    }
    
    func imagePickerController(imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let tempImage = info[UIImagePickerControllerMediaURL] as! NSURL!
        let pathString = tempImage.relativePath
        
        
        UISaveVideoAtPathToSavedPhotosAlbum(pathString!, self, nil, nil) /// video saves here
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("User canceled image")
        dismissViewControllerAnimated(true, completion: {
            
        })
    }
    
    
    func postAlert(title: String, message: String) {
        
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
