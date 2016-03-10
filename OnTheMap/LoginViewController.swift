//
//  ViewController.swift
//  OnTheMap
//
//  Created by Manson Jones on 2/16/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController,
    FBSDKLoginButtonDelegate {
    
    
    // MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // MARK: Properties
    
    let EmailValueKey = "Email Value Key"
    let PasswordValueKey = "Password Value Key"

    var udacityAccountKey: String? = nil
    var appDelegate: AppDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.secureTextEntry = true
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        spinner.hidesWhenStopped = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let emailText  = defaults.stringForKey(EmailValueKey) {
            emailTextField.text = emailText
        }
        if let passwordText = defaults.stringForKey(PasswordValueKey) {
            passwordTextField.text = passwordText
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(emailTextField.text, forKey: EmailValueKey)
        defaults.setObject(passwordTextField.text, forKey: PasswordValueKey)
        
    }
    
    // MARK: FBSDKLoginButtonDelegate functions
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("Facebook login")
        if error == nil {
            print(" facebook login failed ")
        } else {
            print(" facebook login succeeded")
            UdacityClient.sharedInstance().loginToUdacityUsingFacebook()
                { (success, uniqueKey, errorString) in
                    print(" ***** uniqueKey ", uniqueKey!)
                    self.udacityAccountKey = uniqueKey
                    if (success) {
                        performUIUpdatesOnMain {
                            self.completeLogin()
                        }
                    } else {
                        performUIUpdatesOnMain {
                            self.displayError(errorString)
                            self.launchLoginFailAlertView("Invalide Email or Password",message:"Please try again")
                        }
                    }
            }
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
            let _ = segue.destinationViewController as! UITabBarController
        }
    }
    
    func login() {
        if loginErrorHandler() {
            return
        }
        if FBSDKAccessToken.currentAccessToken() != nil {
            print("Facebook token exists")
        } else {
            print("Facebook token does not exist")
        }
        
        spinner.startAnimating()
        
        UdacityClient.sharedInstance().loginToUdacity(
            self.emailTextField.text!,
            password: self.passwordTextField.text!
            ) { (success, uniqueKey, errorString) in
                print(" ***** uniqueKey ", uniqueKey!)
                self.udacityAccountKey = uniqueKey
                if (success) {
                    performUIUpdatesOnMain {
                        self.completeLogin()
                        self.spinner.stopAnimating()
                        print(" **** DEBUG ****")
                        print(UdacityClient.sharedInstance().udacityUserKey!)
                    }
                } else {
                    performUIUpdatesOnMain {
                        self.displayError(errorString)
                        self.spinner.stopAnimating()
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
    
    private func loginErrorHandler() -> Bool {
        if emailTextField!.text! == "" {
            print("The email text field is empty")
            launchLoginFailAlertView("Empty Email", message: "Please try again")
            return true
        }
        if passwordTextField!.text! == "" {
            print("The password text field is empty")
            launchLoginFailAlertView("Empty Password", message: "Please try again")
            return true
        }
        return false
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
    
}

