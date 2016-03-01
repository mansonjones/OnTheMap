//
//  InformationPostingView.swift
//  OnTheMap
//
//  Created by Manson Jones on 2/29/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import UIKit

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
    
    func postStudentLocation() {
        // TODO: get the student information
        // it should be passed into this view controller when the controller
        // is launched.
        // to do: use let/if to check the student object
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
}
