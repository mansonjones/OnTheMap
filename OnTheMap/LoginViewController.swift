//
//  ViewController.swift
//  OnTheMap
//
//  Created by Manson Jones on 2/16/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import UIKit
// import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController,  FBSDKLoginButtonDelegate {
    
    let EmailValueKey = "Email Value Key"
    let PasswordValueKey = "Password Value Key"
    
    // MARK: Properties
    var udacityAccountKey: String? = nil
    
    var appDelegate: AppDelegate!
    
    // MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.secureTextEntry = true
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = NSUserDefaults.standardUserDefaults().stringForKey(EmailValueKey)
        passwordTextField.text = NSUserDefaults.standardUserDefaults().stringForKey(PasswordValueKey)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSUserDefaults.standardUserDefaults().setObject(emailTextField.text, forKey: EmailValueKey)
        NSUserDefaults.standardUserDefaults().setObject(passwordTextField.text, forKey: PasswordValueKey)
    }
    
    // MARK: FBSDKLoginButtonDelegate
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("Facebook login")
        if ((error) == nil) {
            print(" facebook login failed ")
        } else {
            print(" facebook login succeeded")
            // segue to the tab view controller
            
            /*
            let controller = storyboard!.instantiateViewControllerWithIdentifier("MainTabBarController") as!
            UITabBarController
            presentViewController(controller, animated: true, completion: nil)
            */
            performSegueWithIdentifier("ShowMainTabController", sender: self)
        }
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        print("Facebook - loginButtonWillLogin")
        return true
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("Facebook logout")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowMainTabController" {
            let controller = segue.destinationViewController as! UITabBarController
        }
    }
    
    func login() {
        loginErrorHandler()
        
        UdacityClient.sharedInstance().loginToUdacity(
            self.emailTextField.text!,
            password: self.passwordTextField.text!
            ) { (success, uniqueKey, errorString) in
                print(" ***** uniqueKey ", uniqueKey!)
                self.udacityAccountKey = uniqueKey
                if (success) {
                    performUIUpdatesOnMain {
                        self.completeLogin()
                        print(" **** DEBUG ****")
                        print(UdacityClient.sharedInstance().udacityUserKey!)
                    }
                } else {
                    performUIUpdatesOnMain {
                        self.displayError(errorString)
                        self.launchLoginFailAlertView("Invalide Email or Password",message:"Please try again")
                    }
                }
        }
    }
    
    private func displayError(errorString: String?) {
        if let errorString = errorString {
            print(" **** The was an error logging in", errorString)
        }
    }
    
    // TODO: Move this into a different file.
    
    private func loginErrorHandler() {
        if self.emailTextField!.text! == "" {
            print("The email text field is empty")
            launchLoginFailAlertView("Empty Email", message: "Please try again")
        }
        if self.passwordTextField!.text! == "" {
            print("The password text field is empty")
            launchLoginFailAlertView("Empty Password", message: "Please try again")
        }
        
    }
    private func launchLoginFailAlertView(title : String, message : String) {
        let alertController = UIAlertController(title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    private func completeLogin() {
        performSegueWithIdentifier("ShowMainTabController", sender: nil)
        /*
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MainTabBarController") as!
        UITabBarController
        presentViewController(controller, animated: true, completion: nil)
        */
    }
    
    func logout() {
        
        
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
        /* let user_id = "1234"
        
        UdacityClient.sharedInstance().getPublicUserData(user_id) { (statusCode, error) in
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
        } */
        
    }
    
    @IBAction func loginClicked(sender: AnyObject) {
        login()
    }
    
    @IBAction func signUpClicked(sender: AnyObject) {
        let url = "https://www.udacity.com"
        
        if let checkURL = NSURL(string: url) {
            if UIApplication.sharedApplication().openURL(checkURL) {
                print(" url successfully opened")
            }
        } else {
            print("invalide url")
        }
        
    }
    
    @IBAction func facebookClicked(sender: AnyObject) {
        print("facebookClicked")
    }
}

