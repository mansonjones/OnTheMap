//
//  OTMMapViewController.swift
//  OnTheMap
//
//  Created by Manson Jones on 2/16/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import UIKit
import MapKit

class OTMMapViewController: UIViewController,  MKMapViewDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000000
    
    var students: [StudentInformation] = [StudentInformation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Center of U.S.
        // let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.82944)
        let initialLocation = CLLocation(latitude: 39.5, longitude: -98.35)
        centerMapOnLocation(initialLocation)
        // question: How to add more than one bar button item programmatically?
        // There's only one rightBarButtonItem
        createBarButtonItems()
        mapView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: Delete this debug statement
        print(" **** DEBUG ****")
        print(UdacityClient.sharedInstance().udacityUserKey!)
        
        ParseClient.sharedInstance().getStudentLocations { (students, error) -> Void in
            
            if let students = students {
                self.students = students
                print(" *** NUMBER OF ELEMENTS IS")
                print(self.students.count)
                performUIUpdatesOnMain {
                    let annotations = self.buildPointAnnotations()
                    self.mapView.addAnnotations(annotations)
                }
            } else {
                performUIUpdatesOnMain {
                    self.launchAlertView("Download of student information failed", message: "")
                }
            }
            
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowInformationPostingVC" {
            let controller = segue.destinationViewController as! InformationPostingVC
        }
    }
    
    
    private func launchAlertView(title : String, message : String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    private func buildPointAnnotations() -> [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        for student in self.students {
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        return annotations
    }
    
    private func createBarButtonItems() {
        navigationItem.title = "On The Map"
        
        let pinImage = UIImage(named: "pin")!
        
        let pinButton = UIBarButtonItem(image: pinImage, style: .Plain, target: self, action: "addLocation")
        
        
        let updateButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target:self,
            action: "updateTable")
        
        navigationItem.rightBarButtonItems = [updateButton, pinButton]
        let logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logout")
        
        navigationItem.leftBarButtonItem = logoutButton
        
        
    }
    
    // MARK : MapKit Delegate Functions
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
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
    
    // This delegate method is implemented to respond to taps.  It opens the system
    // browser to the URL specified in the annotations subtitle property
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("Hello from calloutAccessoryControlTapped")
        if (control == view.rightCalloutAccessoryView) {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
    private func logoutFromUdacity() {
        UdacityClient.sharedInstance().logoutFromUdacity() {_,_ in
            print(self.students.count)
            performUIUpdatesOnMain {
                self.completeLogout()
            }
        }
        
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("didSelectAnnotationView")
        // TODO: Based on the pin selection, find the user information
        // if let objects = MKAnnotationView. ???
    }
    
    // TODO: Call this function when a pin is to be updated.≥®
    func launchInfoPostingView() {
        
        /*
        let object: AnyObject = storyboard!.instantiateViewControllerWithIdentifier("InformationPostingVC")
        let informationPostingVC = object as! InformationPostingVC
        
        // TODO: pass information to the posting view
        presentViewController(informationPostingVC, animated: true, completion: nil)
        */
        performSegueWithIdentifier("ShowInformationPostingVC", sender: self)
        
    }
    
    // MARK :
    
    
    func addLocation() {
        print("add a pin")
        launchInfoPostingView()
    }
    
    func updateTable() {
        print("update the map")
    }
    
    func logout() {
        print("logout")
        logoutFromUdacity()
        completeLogout()
    }
    
    private func completeLogout() {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("LoginController") as!
        LoginViewController
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    
}
