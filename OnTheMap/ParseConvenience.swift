//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Manson Jones on 2/18/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import Foundation
import UIKit
import Foundation

extension ParseClient {

// MARK: GET Convenience Methods
 
    /*
    func getStudentLocations(student: StudentInformation) {
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
      *
    
    /*
        func queryStudentLocation(student: StudentInformation) {
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
    
    /*
        
        // MARK: POST Convenience Methods
        func postStudenLocation(student: StudentInformation) {
            // 1. Specify parameters
            let parameters = [:]
            
            let udacity = "{\"\(Constants.JSONBodyKeys.Udacity)\":"
            let username = "{\"\(Constants.JSONBodyKeys.Username)\": \"\(student.email)\","
            let password = "\"\(Constants.JSONBodyKeys.Password)\": \"\(student.password)\"}}"
            
            let httpBody = udacity + username + password
            
            // 2. Make the request
            taskForPostMethod(mutableMethod, parameters: parameters, jsonBody: httpBody) { (results,
                error) in
                
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


                // MARK: PUT Convenience Methods
                func updateStudentLocation() {
                    // let mutableMethod =
                    let methodParameters = [:]
                    
                    taskForPUTMethod(String, parameters: methodParameters, jsonBody: httpBody)
                    (results,error) in
                    // 3. Send the desired values to the completion handler
                    if let error = error {
                        completionHandlerForLogout(result: results, error: nil)
                    } else {
                        completionHandlerForLogout(result: nil, error: NSError(domain: "udacity delete parsgin", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse the response from the udacity logout"])
                    }
                }
*/

}