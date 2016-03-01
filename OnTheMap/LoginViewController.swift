//
//  ViewController.swift
//  OnTheMap
//
//  Created by Manson Jones on 2/16/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    // MARK: Properties
    
    var appDelegate: AppDelegate!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.secureTextEntry = true
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func login() {
        // TODO: Figure out which return values from the POST are required for further processing
        
       // let dict = [:]
        
        
        print(" **** email:", self.emailTextField.text!)
        print(" **** password: ", self.passwordTextField.text!)
        
        loginErrorHandler()
        
        UdacityClient.sharedInstance().loginToUdacity(self.emailTextField.text!,
            password: self.passwordTextField.text!) { (statusCode, error) in
            if let error = error {
                print(error)
                self.launchLoginFailAlertView()
            } else {
                self.launchLoginFailAlertView()
                if statusCode == 1 || statusCode == 12 || statusCode == 13 {
                    // self.session = session
                    performUIUpdatesOnMain {
                    //  go ahead and launch the tab bar controller
                        print("launch the tab bar controller")
                        self.completeLogin()
                    }
                } else {
                    performUIUpdatesOnMain {
                        print("Unexpected status code \(statusCode)")
                    }
                }
            }
        }
    }

    // TODO: Move this into a different file.
    
    private func loginErrorHandler() {
        if self.emailTextField!.text! == "" {
            print("The email text field is empty")
            let alertController = UIAlertController(title: "Empty Email",
                message: "",
                preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        if self.passwordTextField!.text! == "" {
            print("The password text field is empty")
            let alertController = UIAlertController(title: "Empty Password",
                message: "",
                preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    private func launchLoginFailAlertView() {
        let alertController = UIAlertController(title: "Blah",
            message: "",
            preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    private func completeLogin() {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MainTabBarController") as!
        UITabBarController
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func logout() {
        let dict = [:]
        
//        let student = StudentInformation(dictionary: dict as! [String : AnyObject])
        
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
                } else {
                    print("Unexpected status code \(statusCode)")
                }
            }
        }
       
    }
    
    func getPublicUserData() {
        UdacityClient.sharedInstance().getPublicUserData() { (statusCode, error) in
            if let error = error {
                print(error)
            } else {
                if statusCode == 1 || statusCode == 12 || statusCode == 13 {
                    // self.session = session
                    // performUIUpdatesOn Main {
                    //  go ahead and launch the tab bar controller
                    // }
                    print("launch the tab bar controller")
                } else {
                    print("Unexpected status code \(statusCode)")
                }
            }
        }
        
    }
        
    @IBAction func loginClicked(sender: AnyObject) {
        login()
        // completeLogin()
        print("loginClicked")
        // Here's one way to do it
        // udacitySession()
        // Here's another way to do it.
 //       logout()
    }


    @IBAction func facebookClicked(sender: AnyObject) {
        print("facebookClicked")
    }
}

