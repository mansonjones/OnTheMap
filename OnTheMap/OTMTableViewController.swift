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


    // let teams = ["Warriors", "Spurs", "Thunder", "Wizards", "Heat"]
    var students = [StudentInformation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBarButtonItems()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Note: This could be built out to work like the MoviePickerViewController.
        ParseClient.sharedInstance().getStudentLocations { (students, error) -> Void in
            if let students = students {
                self.students = students
                print(" *** NUMBER OF ELEMENTS IS")
                print(self.students.count)
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                }
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
        logoutFromUdacity()
        completeLogout()
    }
   
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return teams.count
     //super.\\\\   self.tableView.reloadData()
        print("**** Number Of Rows in Section:", students.count)
        return students.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OTMTableViewCell")!
        
        /*
        cell.textLabel?.text = teams[indexPath.row]
        */
        cell.textLabel?.text = self.students[indexPath.row].firstName + " " + self.students[indexPath.row].lastName
        cell.detailTextLabel?.text = self.students[indexPath.row].mediaURL
        cell.imageView?.image = UIImage(named: "pin")
    
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("this is where you launch the detail view that displays information about the user")
        // open safari browser
        // TODO: pass in the url from the user
        let url = students[indexPath.row].mediaURL
        if let checkURL = NSURL(string: url) {
            if UIApplication.sharedApplication().openURL(checkURL) {
                print(" url successfully opened")
            }
        } else {
            print("invalide url")
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
    
    private func completeLogout() {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("LoginController") as!
        LoginViewController
        presentViewController(controller, animated: true, completion: nil)
    }
    
   
    
    
}
