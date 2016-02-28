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

    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    
    
    
    // the data for the map
    // To Do: Need to replace this with pins, or can pins be generated on the fly?
    // Can pins be a computed property?
    // var pins = [Pin]
    var students: [StudentInformation] = [StudentInformation]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.82944)
        centerMapOnLocation(initialLocation)
        // question: How to add more than one bar button item programmatically?
        // There's only one rightBarButtonItem
        createBarButtonItems()
        mapView.delegate = self
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
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
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //
        // Hard-Code A Pin to appear on the map.
        // This is for layout purposes only.
        let student1 = StudentInformation()
        mapView.addAnnotation(student1)
        /*
        ParseClient.sharedInstance().getStudentLocations { (students, error) in
            print("***** DEBUG ***********")
            if let students = students {
                self.students = students
                
                performUIUpdatesOnMain {
                    // is there an equivalent to reloadData?
                    //   self.??.reloadData()
                    print(" **** debug message from mapviewcontroller **** ")
                }
            } else {
                    print(error)
            }
            
        }
        */
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
