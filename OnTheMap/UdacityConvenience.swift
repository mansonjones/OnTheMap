
//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Manson Jones on 2/18/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import UIKit
import Foundation
import FBSDKLoginKit

extension UdacityClient {
    
    // MARK: GET Convenience Methods
    func getPublicUserData(userID: String,
        completionHandlerForGetPublicUserData: (success: Bool, firstName : String?, lastName : String?, errorString: String?) -> Void) {
            
            // HTTP Get https://www.udacity.com/api/users/<user_id>
            
            let parameters = [String : AnyObject]()
            let method = "\(UdacityClient.Methods.Users)/\(userID)"
            
            // Make the request
            taskForGetMethod(method, parameters: parameters) { (results, error) in
                
                // 3. Send the desired values to the completion handler
                if let error = error {
                    print(error)
                    completionHandlerForGetPublicUserData(success: false,
                        firstName: nil, lastName : nil, errorString: "get public user data failed")
                } else {
                    guard let user = results[UdacityClient.JSONResponseKeys.User] as? [String : AnyObject] else {
                        completionHandlerForGetPublicUserData(success: false, firstName: nil, lastName: nil,
                            errorString: "getPublicUserData failed in parsing user key");
                        return
                    }
                    
                    guard let firstName = user[UdacityClient.JSONResponseKeys.FirstName] as? String else {
                        completionHandlerForGetPublicUserData(success: false, firstName: nil, lastName: nil,
                            errorString: "getPublicUserData failed in parsing user key");
                        return
                    }
                    
                    guard let lastName = user[UdacityClient.JSONResponseKeys.LastName] as? String else {
                        completionHandlerForGetPublicUserData(success: false, firstName: nil, lastName: nil,
                            errorString: "getPublicUserData failed in parsing user key");
                        return
                    }
                    self.firstName = firstName
                    self.lastName = lastName
                    completionHandlerForGetPublicUserData(success: true, firstName: firstName, lastName: lastName,
                        errorString: nil);
                    
                }
                
            }
    }
    
    // MARK: POST Convenience Methods
    
    
    func loginToUdacity(email: String, password: String, completionHandlerForLogin: (success: Bool, uniqueKey : String?, errorString: String?) -> Void) {
        // HTTP Post to https://www.udacity.com/api/session -
        // Creates a Udacity session. Returnss the property uniqueKey for the user
        // 1. Specify parameters
        let parameters = [String : String]()
        
        let httpBody = loginJSONRequest(email, password: password)
        
        taskForPostMethod(UdacityClient.Methods.Session, parameters: parameters, jsonBody: httpBody) {
            (results, error) in
            
            
            // 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForLogin(success: false, uniqueKey: nil, errorString: "Login to Udacity Failed")
            } else {
                
                print("loginToUdacity")
                print(results)
                guard let account = results[UdacityClient.JSONResponseKeys.Account] as? [String : AnyObject] else {
                    completionHandlerForLogin(success: false, uniqueKey: nil, errorString: "Login to Udacity Failed")
                    return
                }
                
                guard let uniqueKey = account[UdacityClient.JSONResponseKeys.Key] as? String else {
                    completionHandlerForLogin(success: false, uniqueKey: nil, errorString: "Login to Udacity Failed")
                    return
                }
                print(" *** loginToUdacity - UniqueKey *** ")
                print(results)
                print("\(uniqueKey)")
                
                self.udacityUserKey = uniqueKey
                
                
                completionHandlerForLogin(success: true, uniqueKey: uniqueKey, errorString: nil)
            }
        }
    }
    
    func loginToUdacityUsingFacebook(completionHandlerForLogin: (success: Bool, uniqueKey : String?, errorString: String?) -> Void) {
        // HTTP Post to https://www.udacity.com/api/session -
        // Creates a Udacity session. Returnss the property uniqueKey for the user
        // 1. Specify parameters
        let parameters = [String : String]()
        
        let httpBody = loginUsingFacebookJSONRequest()
        
        taskForPostMethod(UdacityClient.Methods.Session, parameters: parameters, jsonBody: httpBody) {
            (results, error) in
            
            
            // 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForLogin(success: false, uniqueKey: nil, errorString: "Login to Udacity Failed")
            } else {
                
                print("loginToUdacityFromFacebook")
                print("here's the data")
                print(results)
                // TODO: parse the results correctly
                /*
                print(results)
                guard let account = results[UdacityClient.JSONResponseKeys.Account] as? [String : AnyObject] else {
                completionHandlerForLogin(success: false, uniqueKey: nil, errorString: "Login to Udacity Failed")
                return
                }
                
                guard let uniqueKey = account[UdacityClient.JSONResponseKeys.Key] as? String else {
                completionHandlerForLogin(success: false, uniqueKey: nil, errorString: "Login to Udacity Failed")
                return
                }
                print(" *** loginToUdacity - UniqueKey *** ")
                print(results)
                print("\(uniqueKey)")
                
                self.udacityUserKey = uniqueKey
                
                
                completionHandlerForLogin(success: true, uniqueKey: uniqueKey, errorString: nil)
                */
                
            }
        }
    }
    
    private func loginJSONRequest(email: String, password: String) -> NSData {
        let jsonRequest: [String: AnyObject] = [
            "\(UdacityClient.JSONBodyKeys.Udacity)": [
                "\(UdacityClient.JSONBodyKeys.Username)" : "\(email)",
                "\(UdacityClient.JSONBodyKeys.Password)" : "\(password)"
            ]
        ]
        
        print("****")
        print(jsonRequest)
        
        var httpBody : NSData!
        do {
            httpBody = try NSJSONSerialization.dataWithJSONObject(jsonRequest, options: [])
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(jsonRequest)'"]
            print("\(userInfo)")
        }
        
        /*
        let test2 = try! NSJSONSerialization.JSONObjectWithData(test1, options: .AllowFragments)
        print(" **** JSON2 ***")
        print(test2)
        */
        return httpBody!
    }
    
    private func loginUsingFacebookJSONRequest() -> NSData {
        let accessToken = FBSDKAccessToken.currentAccessToken()
        
        let jsonRequest: [String: AnyObject] = [
            "\(UdacityClient.JSONBodyKeys.FacebookMobile)": [
                "\(UdacityClient.JSONBodyKeys.FacebookAccessToken)" : "\(accessToken)"
            ]
        ]
        
        print("****")
        print(jsonRequest)
        
        var httpBody : NSData!
        do {
            httpBody = try NSJSONSerialization.dataWithJSONObject(jsonRequest, options: [])
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(jsonRequest)'"]
            print("\(userInfo)")
        }
        
        /*
        let test2 = try! NSJSONSerialization.JSONObjectWithData(test1, options: .AllowFragments)
        print(" **** JSON2 ***")
        print(test2)
        */
        return httpBody!
    }
    
    
    // MARK: DELETE Convenience Methods
    func logoutFromUdacity(completionHandlerForLogout: (result: Int?, error: NSError?) -> Void) {
        let parameters = [String:String]()
        
        let method: String = UdacityClient.Methods.Session
        // Note: Maybe remove jsonBody from the argument list if it's never used
        let httpBody = ""
        
        taskForDeleteMethod(method, parameters: parameters, jsonBody: httpBody) {
            (results,error) in
            // 3. Send the desired values to the completion handler
            if let error = error {
                completionHandlerForLogout(result: nil, error: error)
            } else {
                if let results = results[UdacityClient.JSONResponseKeys.StatusCode] as? Int {
                    completionHandlerForLogout(result: results, error: nil)
                } else {
                    completionHandlerForLogout(result: nil, error: NSError(domain: "udacity delete parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse the response from the udacity logout"]))
                }
            }
        }
    }
    
}


