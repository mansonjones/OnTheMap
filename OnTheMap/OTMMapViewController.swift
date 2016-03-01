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
    
    
    
    // the data for the map
    // To Do: Need to replace this with pins, or can pins be generated on the fly?
    // Can pins be a computed property?
    // var pins = [Pin]
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
        
        ParseClient.sharedInstance().getStudentLocations { (students, error) -> Void in
            if let students = students {
                self.students = students
                print(" *** NUMBER OF ELEMENTS IS")
                print(self.students.count)
                performUIUpdatesOnMain {
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
                    self.mapView.addAnnotations(annotations)
                    // create Array of Annotations.
                    // self.mapView.addAnnotations(self.students)
                                    
                    // self.tableView.reloadData()
                }
            }
        }
    }
    
    func createBarButtonItems() {
        // TODO: Get the right artwork for the pin image
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
        /* (
        if let annotation = annotation as? StudentInformation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
                return view
            }
        }
        return nil
         */
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
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("didSelectAnnotationView")
        // TODO: Based on the pin selection, find the user information
        // if let objects = MKAnnotationView. ???
    }
    
    // TODO: Call this function when a pin is to be updated.≥®
    func launchInfoPostingView() {
       let object: AnyObject = storyboard!.instantiateViewControllerWithIdentifier("InformationPostingVC")
        let informationPostingVC = object as! InformationPostingVC
    
        // TODO: pass information to the posting view
        presentViewController(informationPostingVC, animated: true, completion: nil)
    }
    
    // MARK :
    
    func logout1() {
        // TODO: Figure out which return values from the POST are required for further processing
        
        // let dict = [:]
        
        
        UdacityClient.sharedInstance().logoutFromUdacity() { (statusCode, error) in
            if let error = error {
                print(error)
            } else {
                if statusCode == 1 || statusCode == 12 || statusCode == 13 {
                    // self.session = session
                    // performUIUpdatesOn Main {
                    //  go ahead and launch the tab bar controller
                    // }
                    print("launch the tab bar controller")
                    self.completeLogout()
                } else {
                    print("Unexpected status code \(statusCode)")
                }
            }
        }
    }
    
    
    func addLocation() {
        print("add a pin")
        launchInfoPostingView()
    }
    
    func updateTable() {
        print("update the map")
    }
    
    func logout() {
        print("logout")
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
