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
    UINavigationControllerDelegate,
    UITextFieldDelegate
{
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var student = StudentInformation()
    var firstName : String?
    var lastName : String?

    var latitude : CLLocationDegrees?
    var longitude : CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.hidesWhenStopped = true
        self.locationTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        //let udacityUserKey: String? = "u5112578"
        let udacityUserKey = UdacityClient.sharedInstance().udacityUserKey!
        // print("Udacity User Key", udacityUserKey!)
        
        UdacityClient.sharedInstance().getPublicUserData(udacityUserKey) { (success, firstName, lastName, errorString) -> Void in
            if success {
                performUIUpdatesOnMain {
                    print(" **** Debug InformationPostingView - viewWillAppear ****")
                    print(firstName!)
                    print(lastName!)
                    self.firstName = firstName
                    self.lastName = lastName
                    print(" ********** DEBUG FOR FIRSTNAME, LASTNAME **********")
                    print(UdacityClient.sharedInstance().firstName)
                    print(UdacityClient.sharedInstance().lastName)
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
    
    @IBAction func findOnTheMap(sender: UIButton) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = self.locationTextField.text!
        
        let search = MKLocalSearch(request: request)
        
        // start the spinner
        spinner.startAnimating()
        self.latitude = 0.0
        self.longitude = 0.0
        
        search.startWithCompletionHandler { (response, error) -> Void in
            if error != nil {
                performUIUpdatesOnMain({ () -> Void in
                    self.spinner.stopAnimating()
                    self.launchAlertView("Geocding failed for \(self.locationTextField.text!)",
                        message: "error : \(error?.localizedDescription)")
                })
            } else if response?.mapItems.count == 0 {
                performUIUpdatesOnMain({ () -> Void in
                    self.spinner.stopAnimating()
                    print("no matches found")
                    self.launchAlertView("Geocding failed for \(self.locationTextField.text!)",
                        message: "error : list of placemarks is empty")
                })
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
                        self.latitude = geoCodedLatitude!
                        self.longitude = geoCodedLongitude!
                        self.launchEnterALinkViewController(geoCodedLatitude!, longitude: geoCodedLongitude!)
                    })
                    
                }
                
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowEnterALinkViewController" {
            let controller = segue.destinationViewController as! EnterALinkViewController
            controller.latitude = self.latitude
            controller.longitude = self.longitude
        }
    }
    
    func test() {
        performSegueWithIdentifier("ShowEnterALinkViewController", sender: self)
    }
    
    private func launchEnterALinkViewController(latitude : CLLocationDegrees, longitude : CLLocationDegrees) {
        //let controller = storyboard!.instantiateViewControllerWithIdentifier("EnterALinkViewController") as!
       // EnterALinkViewController
        
        /*
        controller.latitude = latitude
        controller.longitude = longitude
         presentViewController(controller, animated: true, completion: nil)
        */
        test()
    }
    
    private func launchAlertView(title : String, message : String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    // Delegate Functiond for UITextFieleDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
