//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Manson Jones on 2/17/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import Foundation

// MARK: - UdacityClient: NSObject

class UdacityClient: NSObject {

    // MARK: Properties
    
    // shared session
    var session = NSURLSession.sharedSession()
    
    // TODO: write the config method
    // var config = UdacityConfig()

    // TODO: do we need to save any authentication state for the Udacity API?

    // MARK: Initializers
    override init() {
        super.init()
    }
    
    
    
    // MARK: GET
    func taskForGetMethod(method: String,
        var parameters: [String:AnyObject],
        completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
            
            // 1. Set the parameters
            // TODO: assign the users key/value pair correctly.
            parameters = [:]
            // parameters[ParameterKeys.Users] = "manson.jones@gmail.com"
            
            // 2/3. Build the URL and configure the request
            // question: can this be done as an NSURLRequest?
            let request = NSMutableURLRequest(URL: udacityURLFromParameters(parameters))

            // 4. Make the request
            let task = session.dataTaskWithRequest(request) { (data, response, error) in
                
                func sendError(error: String) {
                    print(error)
                    let userInfo = [NSLocalizedDescriptionKey: error]
                    completionHandlerForGET(result: nil, error: NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
                }
                
                /* Guard: Was there an error? */
                guard (error == nil) else {
                    sendError("There was an error with your request: \(error)")
                    return
                }
                
                /* Guard: Did we get a successful 2xx response? */
                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where
                    statusCode >= 200 && statusCode <= 299 else {
                        sendError("Your requesgt returned a status cod other than 2xx!")
                        return
                }
                
                /* Guard: Was there any data returned? */
                guard let data = data else {
                    sendError("No data was returned by the request!")
                    return
                }
                self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
            }
            task.resume()
            return task
    }
    
    

    
    // MARK: POST
    func taskForPostMethod(method: String,
        var parameters: [String:AnyObject],
        jsonBody: String,
        completionHandlerForPost: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
            
            // 1. Set the parameters
            parameters = [:]
            
            // 2/3. Build the URL and configure the request
            
            // Set the parameters
            // Build the URL
            // let methodParameters: [String: String] = []
            
            let methodParameters: [String:String!] = [:]
            
            let request = NSMutableURLRequest(URL: udacityURLFromParameters(methodParameters))
            // TODO: Move the code for building the request into it's own function
            // It's OK for now, but pay attention to the way that the system for
            // building requests with bodies is done in the example cod
            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
            
            // 4. Make the request
            let task = session.dataTaskWithRequest(request) { (data, response, error) in
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
                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where
                    statusCode >= 200 &&
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
            return task
    }
    
    // MARK: DELETE
    func taskForDeleteMethod(method: String,
        var parameters: [String:AnyObject],
        jsonBody: String,
        completionHandlerForPost: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
            
            // 1. Set the parameters
            parameters = [:]
            
            // 2/3. Build the URL and configure the request
            
            // Set the parameters
            // Build the URL
            // let methodParameters: [String: String] = []
            
            let methodParameters: [String:String!] = [:]
            
            let request = NSMutableURLRequest(URL: udacityURLFromParameters(methodParameters))
            // TODO: Move the code for building the request into it's own function
            // It's OK for now, but pay attention to the way that the system for
            // building requests with bodies is done in the example cod
            request.HTTPMethod = "DELETE"
            var xsrfCookie: NSHTTPCookie? = nil
            let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
            
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" {
                    xsrfCookie = cookie
                }
            }
            if let xsrfCookie = xsrfCookie {
                // Question: In the project instructions it xsrfCookie.value!
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
            let session = NSURLSession.sharedSession()
        
            // 4. Make the request
            let task = session.dataTaskWithRequest(request) { (data, response, error) in
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
                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where
                    statusCode >= 200 &&
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
            return task
    }
    // Create a URL from parameters
    
    private func udacityURLFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = Constants.Udacity.ApiScheme
        components.host = Constants.Udacity.ApiHost
        components.path = Constants.Udacity.ApiPath + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
    
    // MARK: Helpers
    // given a raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }

}