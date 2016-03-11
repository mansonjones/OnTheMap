//
//  EnterALinkViewController.swift
//  OnTheMap
//
//  Created by Manson Jones on 3/3/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import UIKit
import MapKit

class EnterALinkViewController: UIViewController,
    MKMapViewDelegate,
    UITextFieldDelegate
{
    
    @IBOutlet weak var linkToShare: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    
    var latitude : CLLocationDegrees?
    var longitude : CLLocationDegrees?
    var mapString : String?
    
    let regionRadius : CLLocationDistance = 25000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        linkToShare.delegate = self
        
        let initialLocation = CLLocation(latitude: latitude!, longitude: longitude!)
        
        centerMapOnLocation(initialLocation)
        createBarButtonItems()
        mapView.delegate = self
        let udacityUserKey = UdacityClient.sharedInstance().udacityUserKey!
        
        UdacityClient.sharedInstance().getPublicUserData(udacityUserKey) { (success, firstName, lastName, errorString) -> Void in
            if success {
                performUIUpdatesOnMain {
                    print(" **** Debug EnterALinkViewController - viewDidLoad ****")
                    print(UdacityClient.sharedInstance().firstName)
                    print(UdacityClient.sharedInstance().lastName)
                }
            } else {
                print("error returned by getPublicUserData")
            }
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let latitude = latitude {
            if let longitude = longitude {
                let annotation = MKPointAnnotation()
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                annotation.coordinate = coordinate
                annotation.title = "enter title here"
                annotation.subtitle = "enter subtitle here"
                mapView.addAnnotation(annotation)
            }
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(1.5, delay: 0.5, options: [.CurveEaseInOut], animations: {
            
            let location = CLLocation(latitude: self.latitude!, longitude: self.longitude!)
            
            
            let coordinateRegion =
            MKCoordinateRegionMakeWithDistance(location.coordinate, self.regionRadius, self.regionRadius)
            
            self.mapView.setRegion(coordinateRegion, animated: true)
            
            }, completion: nil)
    }
    
    private func createBarButtonItems() {
        
    }
    // MARK: MapKit Delegate Functions
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        let reuseId = "pin2"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion =
        MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 40, regionRadius * 40)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // UITextFieldDelegate functions
    //
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func cancelThisViewController(sender: AnyObject) {
        // dismiss this controller and return to the main tab bar controller
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MainTabBarController") as!
        UITabBarController
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func postStudentInformation(sender: AnyObject) {
        var userDictionary = [String:AnyObject]()
        
        userDictionary[ParseClient.JSONResponseKeys.FirstName] = UdacityClient.sharedInstance().firstName
        userDictionary[ParseClient.JSONResponseKeys.LastName] = UdacityClient.sharedInstance().lastName
        userDictionary[ParseClient.JSONResponseKeys.UniqueKey] = UdacityClient.sharedInstance().udacityUserKey
        userDictionary[ParseClient.JSONResponseKeys.MapString] = mapString
        userDictionary[ParseClient.JSONResponseKeys.MediaUrl] = linkToShare.text!
        userDictionary[ParseClient.JSONResponseKeys.Latitude] = latitude!
        userDictionary[ParseClient.JSONResponseKeys.Longitude] = longitude!
        
        let user = StudentInformation(dictionary: userDictionary)
        ParseClient.sharedInstance().postStudenLocation(user) { (statusCode, error) -> Void in
            if let error = error {
                print(error)
            } else {
                if statusCode == 1 || statusCode == 12 || statusCode == 13 {
                    print(" student information was successfully posted")
                } else {
                    print(" Unexpected status code returned when trying to post student data \(statusCode)")
                }
            }
        }
    }
    
    
}
