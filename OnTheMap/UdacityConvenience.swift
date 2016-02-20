//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Manson Jones on 2/18/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import UIKit
import Foundation

extension UdacityClient {
    // MARK: GET Convenience Methods
    /*
    func loginToFacebook() {
    let parameters = [:]
    let httpBody = ""
    
    // 2. Make the request
    taskForPostMethod("", parameters: parameters, jsonBody: httpBody) { (results, error) in
    
    // 3. Send the desired value(s) to completion handler
    if let error = error {
    completionHandlerForLogin(result: nil, error: error)
    } else {
    if let results = results[UdacityClient.JSONResponseKeys.StatusCode] as? Int {
    compleletionHandlerForLogin(result: results, error: nil)
    } else {
    completionHandlerForFavorite(result: nil, error: NSError(domain: "udacity login parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse udacity login post list"]))
    }
    }
    }
    */
    
    func getPublicUserData(
        completionHandlerForGetPublicUserData: (result: Int?, error: NSError?) -> Void) {
        // HTTP Get https://www.udacity.com/api/users/<user_id>
        
            let parameters = [Constants.ParameterKeys.Users: "putTheUserIdHere"]
            
            // Make the request
            taskForGetMethod("blah", parameters: parameters) { (results, error) in
    
            // 3. Send the desired values to the completion handler
            if let error = error {
                print(error)
                completionHandlerForGetPublicUserData(result: nil, error: error)
            } else {
                print(" successful return from getPublicUserData")
                /* TODO: handle the output
                if let userID = results[Constants.JSONResponseKeys.UserID] as? Int {
                    completionHandlerForGetPublicUserData(success: true, userID: userID, errorString: nil)
                } else {
                    print("Could not find \(Constants.JSONResponseKeys,UserID) in \(results)")
                    completionHandlerForGetPublicUserData(success: false, userID: nil, errorString: "Login Failed (User ID).")
                }
                */
                }
            }
    }
    

    // MARK: POST Convenience Methods
    func loginToUdacity(student: StudentInformation, completionHandlerForLogin: (result: Int?, error: NSError?) -> Void) {
        // HTTP Post to https://www.udacity.com/api/session -
        // Sets the ?? property on the StudentInformation record
        // 1. Specify parameters
        let parameters = ["":""]
        
        let method: String = Constants.Methods.Session
        
        let udacityKey = "{\"\(Constants.JSONBodyKeys.Udacity)\":"
        let usernamePair = "{\"\(Constants.JSONBodyKeys.Username)\": \"\(student.email)\","
        let passwordPair = "\"\(Constants.JSONBodyKeys.Password)\": \"\(student.password)\"}}"
        
        let httpBody = udacityKey + usernamePair + passwordPair
        
        // 2. Make the request
        taskForPostMethod(method, parameters: parameters, jsonBody: httpBody) {
            (results, error) in
            
            // 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForLogin(result: nil, error: error)
            } else {
                if let results = results[Constants.JSONResponseKeys.StatusCode] as? Int {
                    completionHandlerForLogin(result: results, error: nil)
                } else {
                    completionHandlerForLogin(result: nil, error: NSError(domain: "udacity login parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse udacity login post list"]))
                }
            }
        }
    }

    // MARK: DELETE Convenience Methods
    func logoutFromUdacity(completionHandlerForLogout: (result: Int?, error: NSError?) -> Void) {
        let parameters = ["":""]
        
        let method: String = Constants.Methods.Session
        // Note: Maybe remove jsonBody from the argument list if it's never used
        let httpBody = ""
        
        taskForDeleteMethod(method, parameters: parameters, jsonBody: httpBody) {
            (results,error) in
            // 3. Send the desired values to the completion handler
            if let error = error {
                completionHandlerForLogout(result: nil, error: error)
            } else {
                if let results = results[Constants.JSONResponseKeys.StatusCode] as? Int {
                    completionHandlerForLogout(result: results, error: nil)
                } else {
                    completionHandlerForLogout(result: nil, error: NSError(domain: "udacity delete parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse the response from the udacity logout"]))
                }
            }
        }
            }
            
}


