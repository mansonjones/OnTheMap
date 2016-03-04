//
//  EnterALinkViewController.swift
//  OnTheMap
//
//  Created by Manson Jones on 3/3/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import UIKit
import MapKit

class EnterALinkViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var linkToShare: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    let regionRadius : CLLocationDistance = 1000000
    
    // TODO: pass in the location
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initialLocation = CLLocation(latitude: 39.5, longitude: -98.35)
        
        centerMapOnLocation(initialLocation)
        createBarButtonItems()
        mapView.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // linkToShare.text = "bogus"
    }
    
    private func createBarButtonItems() {
        
    }
    
    @IBAction func postStudentInformation(sender: AnyObject) {
        print("Post Student Information")
        /*
        let studentInfo = [ParseClient.JSONResponseKeys.MapString : "blah" /* linkToShare.text */ ]
        let student = StudentInformation(dictionary: studentInfo)
        ParseClient.sharedInstance().postStudenLocation(student) { (statusCode, error) -> Void in
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
        */
    }
    
    // MARK: MapKit Delegate Functions
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        let reuseId = "pin2"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.yellowColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }

    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion =
        MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }


}
