//
//  MapView.swift
//  Live_reporting
//
//  Created by user on 2/11/15.
//  Copyright © 2015 LiveReporting. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Parse
import Bolts


class MapView: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {

    @IBOutlet weak var mapView: MKMapView!
      /*  {
        didSet{
        mapView.mapType = .Satellite
        mapView.delegate = self
        }
    }*/
    let locationManager = CLLocationManager()
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    var currentLoc: PFGeoPoint! = PFGeoPoint()
    
    
    
    
    
    @IBAction func showSearchBar(sender: AnyObject) {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        presentViewController(searchController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       /// To start updating USER LOCATION ///////////////
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.delegate = self
        
      ///////
        
        
        
        ///// TO ZOOM INTO THE USERLOCATION IN THE MAP //////
        let location = CLLocationCoordinate2DMake(9.9583736, 2.3922926)
        let span = MKCoordinateSpanMake(0.5, 0.5)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
      /////////////////
        
    }
    

    
    /////// TO DIsplay Annotation's CallOUt ///////////
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
    
        let reuseId = "test"
        let image2 = UIImage(named: "live.gif")!
                var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
        }
        else {
            anView!.annotation = annotation
        }
        anView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIButton
      
        if (annotation is CustomPointAnnotation)
        { let cpa = annotation as! CustomPointAnnotation
            anView!.image = UIImage(named:cpa.imageName)
            let imageTest = UIImage(named: cpa.thumbnail)
         anView!.leftCalloutAccessoryView = UIImageView(image: imageTest)
        }
            
        else {
            anView!.image = UIImage(named: "live.gif")
        }
        
        
        return anView
    }
    
    
    ///////////
    
    
    //////// Action to commit when the user selects the Annotation CallOut ///////////
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("you have clicked on the annotation callout \(view.annotation?.title)")
        
        let cp = view.annotation as! CustomPointAnnotation
        let im = cp.title
        if im == "Number 1"
        {
            print("Clicked on: \(im)") }
        else
        {
            print("Doesnot work that way")
        }
        
       
       

    }
    
    ////////////////////////////
    
    
    
    //////////// To design Custom Annotation /////////////////////
    
    class CustomPointAnnotation: MKPointAnnotation {
        var imageName: String!
        var thumbnail: String!
    }
    
   /////////////////////////////////////
    
    
    
    //// Loading UserLocations (Live as well as other videos) from Parse ///////////////
    
    override func viewDidAppear(animated: Bool) {
        let annotationQuery = PFQuery(className: "mapView")
        var liveCheck = 0
        
      //  currentLoc = PFGeoPoint(location: locationManager.location)
      // annotationQuery.whereKey("userLocation", nearGeoPoint: currentLoc, withinMiles: 10)
        
        
        annotationQuery.findObjectsInBackgroundWithBlock {
            (posts, error) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successful query for annotations")
                let myPosts = posts! as [PFObject]
                
                for post in myPosts {
                    let point = post["userLocation"] as! PFGeoPoint
                   
                        
                   
                
                   let name = post["userId"] as! String
                    let liveOrNot = post["live"] as! Int
                    let annotation = CustomPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude)
                    annotation.title = name
                   
                    ///Receive Live number
                    
                    liveCheck = liveOrNot
                   
                    if liveCheck == 0 {
                        annotation.imageName = "liveBlue.png"
                        
                    }
                    else
                    { annotation.imageName = "liveRed.png"
                    }
                   annotation.thumbnail = "liveRed.png"
                    
                    self.mapView.addAnnotation(annotation)
                }
            } else {
               
                print("Error: \(error)")
            }
        }
        
    }
    //////////////////////////////////////////////
    
    
    ///////////////// SearchBar Action in the MAP //////////////////////////
  

    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        //1
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        }
    }

   //////////////////////////////////

}
