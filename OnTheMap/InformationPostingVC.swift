//
//  InformationPostingView.swift
//  OnTheMap
//
//  Created by Manson Jones on 2/29/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingVC: UIViewController,
    UINavigationControllerDelegate
{
    
    var student: StudentInformation!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelInformationEditor() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func postStudentLocation(sender: AnyObject) {
        print("post student information to server")
       // launch.AlertView("Could Not Geocode the String", message : "")
    }
    
    func postStudentLocation() {
        // TODO: get the student information
        // it should be passed into this view controller when the controller
        // is launched.
        // to do: use let/if to check the student object
        print("Posting Student Locations")
        ParseClient.sharedInstance().postStudenLocation(student) { (statusCode, error) -> Void in
            if let error = error {
                print(error)
            } else {
                if statusCode == 1 || statusCode == 12 || statusCode == 13 {
                    performUIUpdatesOnMain{
                        print("Perform UI updates on main")
                    }
                } else {
                    print("Unexpected status code \(statusCode)")
                }
            }
        }
    }
    
    private func geocode() {
        // Use CLGeocoder's geocodeAddressString() or
        // MKLocalSearch's
        // startWithCompletionHandler
        // To Do: Show a spinner while the geoCode is being computed.
        // Given a city name, find the latitude and longitude.
        /*
        var geocoder = CLGeocoder()
        let addressString = "Dallas"
        geocoder.geocodeAddressString(<#T##addressString: String##String#>) { (placemarks : [CLPlacemark], ErrorType) -> Void in
            let placemark = placemark[0]
            
        }
        */
        
        
    }
    
    private func launchAlertView(title : String, message : String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
}
