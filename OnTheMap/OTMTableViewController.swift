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

    let teams = ["Warriors", "Spurs", "Thunder", "Wizards", "Heat"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBarButtonItems()
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
        print("add a pin")
        let object: AnyObject = storyboard!.instantiateViewControllerWithIdentifier("InformationPostingVC")
        let informationPostingVC = object as! InformationPostingVC
        
        // TODO: pass information to the posting view
        presentViewController(informationPostingVC, animated: true, completion: nil)
    }
    
    func updateTable() {
        print("update the table")
    }
    
    func logout() {
        print("logout")
    }
   
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OTMTableViewCell")!
        
        cell.textLabel?.text = teams[indexPath.row]
        cell.imageView?.image = UIImage(named: "pin")
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("this is where you launch the detail view that displays information about the user")
        // open safari browser
        // TODO: pass in the url from the user
        if let checkURL = NSURL(string: "https://news.ycombinator.com") {
            if UIApplication.sharedApplication().openURL(checkURL) {
                print(" url successfully opened")
            }
        } else {
            print("invalide url")
        }
    }
    
}
