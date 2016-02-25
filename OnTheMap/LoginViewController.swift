//
//  ViewController.swift
//  OnTheMap
//
//  Created by Manson Jones on 2/16/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: Properties
    
    var appDelegate: AppDelegate!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func udacitySession() {
            // Set the parameters
            // Build the URL
            // let methodParameters: [String: String] = []
        let methodParameters: [String:String!] = [:]
        let request = NSMutableURLRequest(URL: appDelegate.udacityURLFromParameters(methodParameters))
        // TODO: Move the code for building the request into it's own function
        // It's OK for now, but pay attention to the way that the system for
        // building requests with bodies is done in the example cod
            
            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // question: Can the query?? function be used to build this string?
        // Do I need to escape the quotation marks?
        // This is just a guess
        let componentsTest = NSURLComponents()
        // Arg! This next bit doesn't work
        /*
        let q1 = NSURLQueryItem(name: "k1", value: "v1")
        componentsTest.queryItems!.append(q1)
        let q2 = NSURLQueryItem(name: "k2", value: "v2")
        componentsTest.queryItems!.append(q2)
        print(componentsTest.URL!)
        */
        let udacity = "{\"" + UdacityClient.JSONBodyKeys.Udacity + "\":"
        let username = "{\"" + UdacityClient.JSONBodyKeys.Username + "\": \"" + self.emailTextField.text! + "\","
        let password = "\"" + UdacityClient.JSONBodyKeys.Password + "\": \"" + self.passwordTextField.text! + "\"}}"
        
        let httpBody = udacity + username + password
        
        request.HTTPBody = httpBody.dataUsingEncoding(NSUTF8StringEncoding)
        // 4. Make the request
        let task = appDelegate.sharedSession.dataTaskWithRequest(request) { (data, response, error) in
            
                // if any error occurs, print it and re-enable the UI
            func displayError(error: String, debugLabelText: String? = nil) {
                print(error)
                    // performUIpdatesOnMain {
            //            self.setUIEnabled(true)
                  //      self.debugTextLabel.text = "Login Failed (Login Step)."
                //    }
            }
            
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
            print("Here's the DATA!!!")
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            /* Guard: Was there an error? */
            guard (error == nil) else {
                displayError("There was an error with your request: \(error)")
                return
            }
            
            /* Guard: Did we get a successful 2xx response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 &&
                statusCode <= 299 else {
                    displayError("Your request returned a status code other than 2xx!")
                    return
            }
            
            /* Guard: Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            /* 5. Parse the data */
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
                print("Here's the parsed result!")
                print(parsedResult)
                guard let accountKey = parsedResult["account.key"] as? Int else {
                    displayError("Cannot find account key")
                    return
                }
                
                print("account key", accountKey)
                print("accont registered")
                print("expirgation")
                print("id")
            } catch {
                displayError("Could not parse the data as JSON: '\(data)/")
            }
            
            /* Guard: Did Udacity return an error? */
           // if let _ = parsedResult[Constants.UdacityResponseKeys.StatusCode] as? Int {
           //     displayError("The Udacity server returned an error. See the ")
           //     return
            // }
            
            // 6. Use The data!
            // Guard: Is the success key in parseResult?
            
            /* Use the data */
            // self.getSessionID(self.appDelegate.requestToken)
        }
        task.resume()
    }
    
    func login() {
        // TODO: Figure out which return values from the POST are required for further processing
        
       // let dict = [:]
        
        
        print(" **** email:", self.emailTextField.text!)
        print(" **** password: ", self.passwordTextField.text!)
        
        let studentInfo = [
            UdacityClient.JSONBodyKeys.Username : self.emailTextField.text!,
            UdacityClient.JSONBodyKeys.Password : self.passwordTextField.text!
        ]
        
        let student = StudentInformation(dictionary: studentInfo)
        // let student = StudentInformation(dictionary: dict as! [String : AnyObject])
        
        print(" *** student")
        print("(student)")
            
        UdacityClient.sharedInstance().loginToUdacity(student) { (statusCode, error) in
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
        completeLogin()
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

