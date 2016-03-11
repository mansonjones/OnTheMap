//
//  OTMTableViewController.swift
//  OnTheMap
//
//  Created by Manson Jones on 2/18/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import UIKit

class OTMTableViewController: UITableViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        createBarButtonItems()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Note: This could be built out to work like the MoviePicker view controller
        // TODO: Display an alert view if the download fails.
        updateMap()
    }
    
    func updateMap() {
        ParseClient.sharedInstance().getStudentLocations { (students, error) -> Void in
            if let students = students {
                OTMModel.students = students
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                }
            } else {
                self.launchAlertView("Download of Student Data Failed", message : "")
            }
        }
        
    }
    func createBarButtonItems() {
        navigationItem.title = "On The Map"
        
        // TODO: Get the right artwork for the pin image
        
        let pinImage = UIImage(named: "pin")!
        
        let pinButton = UIBarButtonItem(image: pinImage, style: .Plain, target: self, action: "addLocation")
        
        let updateButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "updateTable")
        navigationItem.rightBarButtonItems = [updateButton, pinButton]
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logout")
        
        navigationItem.leftBarButtonItem = logoutButton
    }
    
    func addLocation() {
        /*
        let object: AnyObject = storyboard!.instantiateViewControllerWithIdentifier("InformationPostingVC")
        let informationPostingVC = object as! InformationPostingVC
        
        // TODO: pass information to the posting view
        presentViewController(informationPostingVC, animated: true, completion: nil)
        */
        performSegueWithIdentifier("ShowInformationPostingVC", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowInformationPostingVC" {
            _ = segue.destinationViewController as! InformationPostingVC
        }
    }
    
    
    func updateTable() {
        updateMap()
    }
    
    func logout() {
        logoutFromUdacity()
        completeLogout()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OTMModel.students.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OTMTableViewCell")!
        
        /*
        cell.textLabel?.text = teams[indexPath.row]
        */
        cell.textLabel?.text = OTMModel.students[indexPath.row].firstName + " " + OTMModel.students[indexPath.row].lastName
        cell.detailTextLabel?.text = OTMModel.students[indexPath.row].mediaURL
        cell.imageView?.image = UIImage(named: "pin")
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let url = OTMModel.students[indexPath.row].mediaURL
        if let checkURL = NSURL(string: url) {
            if UIApplication.sharedApplication().openURL(checkURL) {
                print(" url successfully opened")
            }
        } else {
            print("invalid url")
        }
    }
    
    private func logoutFromUdacity() {
        UdacityClient.sharedInstance().logoutFromUdacity() {_,_ in
            performUIUpdatesOnMain {
                self.completeLogout()
            }
        }
        
    }
    
    private func completeLogout() {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("LoginController") as!
        LoginViewController
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
