//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Manson Jones on 2/18/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import Foundation
import UIKit

extension ParseClient {
    
    // MARK: GET Convenience Methods
    
    
    // TODO: Would it be more intuitive to call this function
    // getUdacityStudentLocations?
    // Would getStudentInformation be a better name?
    // Would it be better to provide the limit of 100 students as an input?
    
    func getStudentLocations(
        completionHandlerForStudentLocations: (result: [StudentInformation]?, error: NSError?) -> Void) -> NSURLSessionDataTask {
            
            /* https://api.parse.com/1/classes/StudentLocation?limit=100 */
            
            //
            
            let parameters = [
                ParseClient.ParameterKeys.Limit : 100,
                ParseClient.ParameterKeys.Order : "-updatedAt"
            ]
            
            let task = taskForGETMethod(ParseClient.Methods.StudentLocation, parameters: parameters) { (results, error) in
                
                // 3. Send the values to the completion handler
                if let error = error {
                    print(error)
                    completionHandlerForStudentLocations(result : nil, error: error)
                } else {
                    
                    if let results = results[ParseClient.JSONResponseKeys.StudentResults] as? [[String : AnyObject]] {
                        let students = StudentInformation.studentsFromResults(results)
                        completionHandlerForStudentLocations(result: students, error: nil)
                    } else {
                        completionHandlerForStudentLocations(result: nil, error: NSError(domain: "getStudentLocations parsing", code: 0,
                            userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                    }
                    
                }
            }
            return task
    }
    
    
    /*
    func queryStudentLocation(result: [StudentInformation]?, error: NSError?) -> Void) -> NSURLSessionDataTask {
    
      /* https://api.parse.com/1/classes/StudentLocation */
    
    let parameters = [
    
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
    func postStudenLocation(student: StudentInformation, completionHandlerForStudentLocation: (result: Int?, error: NSError?) -> Void) {
        // 1. Specify parameters
        // https://api.parse.com/1/classes/StudentLocation
        
        // let parameters [String: Anyobject]= [] // need to add user info
        // let parameters = ["skip" : 400]
        
        let parameters = [String: String]()
        
        let httpBody = postStudentLocationJSONRequest(student)
        
        taskForPostMethod(ParseClient.Methods.StudentLocation, parameters: parameters, jsonBody: httpBody) { (results, error) in
            
            if let error = error {
                completionHandlerForStudentLocation(result: nil, error: error)
            } else {
                /*
                if let result = results[ParseClient.JSONResponseKeys.StatusCode] as? Int {
                completionHandlerForStudentLocation(result: result, error: nil)
                } else {
                completionHandlerForStudentLocation(result: nil, error: NSError(domain: "postStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postStudentLocation list"]))
                }
                */
            }
            
        }
    }
    
    private func postStudentLocationJSONRequest(student : StudentInformation) -> NSData {
        // Note that this is used by put and post.  maybe change the name
        // to studentLocationJSONRequest, or studentLocationHTTPBody
        // or httpBodyForPostAndPut
        
        let jsonRequest: [String: AnyObject] = [
            "\(ParseClient.JSONBodyKeys.UniqueKey)" : "\(student.uniqueKey)",
            "\(ParseClient.JSONBodyKeys.FirstName)" : "\(student.firstName)",
            "\(ParseClient.JSONBodyKeys.LastName)" : "\(student.lastName)",
            "\(ParseClient.JSONBodyKeys.MapString)" : "\(student.mapString)",
            "\(ParseClient.JSONBodyKeys.MediaUrl)" : "\(student.mediaURL)",
            "\(ParseClient.JSONBodyKeys.Latitude)" : "\(student.latitude)",
            "\(ParseClient.JSONBodyKeys.Longitude)" : "\(student.longitude)"
        ]
        
        print("****")
        print(jsonRequest)
        
        let httpBody = try! NSJSONSerialization.dataWithJSONObject(jsonRequest, options: [])
        print("  ****  JSON1  ****")
        print(httpBody)
        
        /*
        let test2 = try! NSJSONSerialization.JSONObjectWithData(test1, options: .AllowFragments)
        print(" **** JSON2 ***")
        print(test2)
        */
        return httpBody
    }
    
     // MARK: PUT Convenience Methods
    /*
    func updateStudentLocation(student: StudentInformation) {
    // ToDo: need to pass in the 
    // let httpBody = postStudentJSONRequest
    // let mutableMeth
    let parameters = [ String : String]()
    let parameters = ["where: ["uniqueKey":"1234"]]
    // Make The request
    
    taskForPUTMethod(ParseClient.Methods.StudentLocation, parameters: parameters, jsonBody: httpBody)
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