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
    func getPublicUserData(student: StudentInformation) {
        let methodParameters = [:] // need to add user info
        taskForGetMethod("blah", parameters: methodparameters) { (results, error) in
            
            // 3. Send the desired values to the completion handler
            if let error = error {
                print(error)
                completionHanlderForUserID(success: false, userID: nil, errorString: "get public user data failed")
            } else {
                if let userID = results[UdacityClient.JSONResponseKeys.UserID] as? Int {
                    completionHandlerForPublicUserData(success: true, userID: userID, errorString: nil)
                } else {
                    print("Could not find \(UdacityClient.JSONResponseKeys,UserID) in \(results)")
                    completionHandlerForUserID(success: false, userID: nil, errorString: "Login Failed (User ID).")
                }
            }
    }
    
    */
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
}
      
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
    
        /*
        // MARK: DELETE Convenience Methods
        func logoutFromUdacity() {
            // let mutableMethod =
            let methodParameters = [:]
            
            taskForDeleteMethod(String, parameters: methodParameters, jsonBody: httpBody)
            (results,error) in
            // 3. Send the desired values to the completion handler
            if let error = error {
                completionHandlerForLogout(result: results, error: nil)
            } else {
                completionHandlerForLogout(result: nil, error: NSError(domain: "udacity delete parsgin", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse the response from the udacity logout"])
            }
        }
        */