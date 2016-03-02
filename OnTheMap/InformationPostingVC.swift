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
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var student: StudentInformation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.hidesWhenStopped = true
    }
    
    @IBAction func cancelInformationEditor() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func postStudentLocation(sender: AnyObject) {
        print("post student information to server")
        geocode()
        // launch.AlertView("Could Not Geocode the String", message : "")
    }
    
    func postStudentLocation() {
        // TODO: get the student information
        // it should be passed into this view controller when the controller
        // is launched.
        // to do: use let/if to check the student object
        print("Posting Student Locations")
        geocode()
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
        spinner.startAnimating()
        
        print(" **** Geo code **")
//        let address = "15426 Bestor Blvd., Pacific Palisades, CA"
        let address = "aldfkjasl;dfjas"
        // Start the spinner
        CLGeocoder().geocodeAddressString(address) { (placemarks : [CLPlacemark]?, error: NSError?) -> Void in
            print("Hello From geocode ")
            print(" **** Number of placemerks ****")
            print(placemarks!.count)
            for placemark in placemarks! {
                print("\(placemark)")
            }
            // close the spinner
        }
        // Use MKLocal
        //
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = address
        
        let search = MKLocalSearch(request: request)
        
        // start the spinner
        
        search.startWithCompletionHandler { (response, error) -> Void in
            print("hello")
            
            
            // TODO: Display an alert if geocoding fails.
            if error != nil {
                print("error occured in search: \(error?.localizedDescription)")
                self.launchAlertView("blah", message: "dee blah")
            } else if response?.mapItems.count == 0 {
                print("no matches found")
                self.launchAlertView("blah", message: "dee blah")
            } else {
                for item in response!.mapItems {
                    
                    print("\(item.name)")
                    print("\(item.placemark.location)")
                    let latitude = item.placemark.location?.coordinate.latitude
                    let longitude = item.placemark.location?.coordinate.longitude
                    print("\(latitude!)")
                    print("\(longitude!)")
                    performUIUpdatesOnMain({ () -> Void in
                        self.spinner.stopAnimating()
                    })
                    
                }
                
            }
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
    
}
