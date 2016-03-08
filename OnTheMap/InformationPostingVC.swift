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
    var student = StudentInformation()
    var firstName : String?
    var lastName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.hidesWhenStopped = true
        // TODO: Either pass the userid from the login view or make it available 
        // otherwise.
        // Could even create a User record for saving this stuff, with it's own
        // special function for populating it.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: The value of the UdacityUserKey should be read from
        // somwhere else.  It is manually set here as a convenience
        // for testing.
        
        let udacityUserKey: String? = "u5112578"
        print("Udacity User Key", udacityUserKey!)
        
        UdacityClient.sharedInstance().getPublicUserData(udacityUserKey!) { (success, firstName, lastName, errorString) -> Void in
            if success {
                performUIUpdatesOnMain {
                    print(" **** Debug ****")
                    print(firstName!)
                    print(lastName!)
                    self.firstName = firstName
                    self.lastName = lastName
                }
            } else {
                print("error returned by getPublicUserData")
            }
        }
        print(" **** InformationPostingVC - viewWillAppear - ")
        print(self.firstName)
        print(self.lastName)
        print(" *** another approach")
        print(UdacityClient.sharedInstance().firstName)
        print(UdacityClient.sharedInstance().lastName)
    }
    
    @IBAction func cancelInformationEditor() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func postStudentLocation(sender: AnyObject) {
        print("post student information to server")
        let (latitude, longitude) = geocode()
        // let latitudePacPal = 34.035633
        // let longitudePacPal = -118.51559

        launchEnterALinkViewController(latitude, longitude : longitude)
        // launch.AlertView("Could Not Geocode the String", message : "")
    }
    
    func postStudentLocation() {
        geocode()
        // Post Search String and coordintes to the RESTful service
        // TODO: Display an alert if the post fails.
        /*
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
        */
    }
    
    private func geocode() -> (latitude : CLLocationDegrees, longitude : CLLocationDegrees) {
        // Use CLGeocoder's geocodeAddressString() or
        // MKLocalSearch's
        // startWithCompletionHandler
        // To Do: Show a spinner while the geoCode is being computed.
        // Given a city name, find the latitude and longitude.
        /*
         spinner.startAnimating()
        
        print(" **** Geo code **")
        let address = "15426 Bestor Blvd., Pacific Palisades, CA"
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
        */
        
        let address = "15426 Bestor Blvd., Pacific Palisades, CA"
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = address
        
        let search = MKLocalSearch(request: request)
        
        // start the spinner
        var latitude: CLLocationDegrees = 0
        var longitude: CLLocationDegrees = 0
        
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
                    let geoCodedLatitude = item.placemark.location?.coordinate.latitude
                    let geoCodedLongitude = item.placemark.location?.coordinate.longitude
                    print("LATITUDE = \(geoCodedLatitude!)")
                    print("LONGITUDE = \(geoCodedLongitude!)")
                    performUIUpdatesOnMain({ () -> Void in
                        self.spinner.stopAnimating()
                        latitude = geoCodedLatitude!
                        longitude = geoCodedLongitude!
                    })
                    
                }
                
            }
        }
        return (latitude,longitude)
    }
    
    private func launchEnterALinkViewController(latitude : CLLocationDegrees, longitude : CLLocationDegrees) {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("EnterALinkViewController") as!
        EnterALinkViewController
        
        // controller.student = student
        // TODO: Put these in if-let statements.
        
        controller.latitude = latitude
        controller.longitude = longitude
        presentViewController(controller, animated: true, completion: nil)
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
