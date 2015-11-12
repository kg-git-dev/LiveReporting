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
import MapKit
import CoreLocation

class MainPageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {

let locationManager = CLLocationManager()
var currentLoc: PFGeoPoint! = PFGeoPoint()
    var vidId:String!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /// To start updating USER LOCATION ///////////////
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
      //  self.mapView.delegate = self
        
        ///////
        
        
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
        
        //Adding the userLocation in the MapView//
        
        let newVid = PFObject(className: "mapView")
        newVid["userId"] = PFUser.currentUser()?.username
        newVid["userLocation"] = currentLoc
        newVid["live"] = 1
        newVid.saveInBackgroundWithBlock {
            (success, error) -> Void in
            if success {
                self.vidId = newVid.objectId
                print("Object Id: \(self.vidId)")
            }
        }
        
        
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
        let vidXX = NSData(contentsOfFile: pathString!)! as NSData
      //  let videoFile = PFFile(name: "XXX.MOV", contentsAtPath: pathString!)
        
        //Saving the Vid //
        let query = PFQuery(className: "mapView")
        query.getObjectInBackgroundWithId(vidId) {
            (vid: PFObject?, error: NSError?) -> Void in
            if error != nil
            {
                print(error)
            }
            else if let vid = vid {
                vid["video"] = vidXX
                vid["live"] = 0
                vid.saveInBackground()
            }
        }
        
        ///////////////////////////
        
        
        
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

    
    
///// USERLOCATION UPDATE /////////////////



func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {

(placemarks, error) -> Void in



if(error != nil)

{

print("Error: " + error!.localizedDescription)

return

}



if placemarks!.count > 0

{

let pm = placemarks![0]

self.displayLocationInfo(pm)

}

})



}











func displayLocationInfo(placemark: CLPlacemark)

{

self.locationManager.stopUpdatingLocation()

print(placemark.locality)

print(placemark.administrativeArea)

print(placemark.country)

let loc = placemark.location!.coordinate

print("Latitude: \(loc.latitude)")

print("Longitude: \(loc.longitude)")



currentLoc = PFGeoPoint(latitude: loc.latitude, longitude: loc.longitude)
    
    if let currentUser = PFUser.currentUser(){
        currentUser["userLocation"] = currentLoc
        currentUser.saveInBackground()
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
