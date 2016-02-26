//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Manson Jones on 2/17/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import Foundation

// MARK: - parseClient: NSObject

class ParseClient: NSObject {
    
    // MARK: Properties
    
    // shared session
    var session = NSURLSession.sharedSession()
    
    // TODO: write the config method
    // var config = parseConfig()
    
    // TODO: do we need to save any authentication state for the parse API?
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    
    
    // MARK: GET
    func taskForGETMethod(method: String,
        var parameters: [String:AnyObject],
        completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
            
            // 1. Set the parameters
            // TODO: assign the users key/value pair correctly.
        //    parameters = [:]
            // parameters[ParameterKeys.Users] = "manson.jones@gmail.com"
            
            // 2/3. Build the URL and configure the request
            // question: can this be done as an NSURLRequest?
            let request = NSMutableURLRequest(URL: parseURLFromParameters(parameters, withPathExtension: method))
            request.addValue(ParseClient.Constants.ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(ParseClient.Constants.ParseRESTApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
            
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
            // parameters = [:]
            
            // 2/3. Build the URL and configure the request
            
            // Set the parameters
            // Build the URL
            // let methodParameters: [String: String] = []
            
            // let methodParameters: [String:String!] = [:]
            
            let request = NSMutableURLRequest(URL: parseURLFromParameters(parameters, withPathExtension: method))
            // TODO: Move the code for building the request into it's own function
            // It's OK for now, but pay attention to the way that the system for
            // building requests with bodies is done in the example cod
            request.HTTPMethod = "POST"
            request.addValue(ParseClient.Constants.ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(ParseClient.Constants.ParseRESTApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
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
            
            let request = NSMutableURLRequest(URL: parseURLFromParameters(methodParameters))
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
                
                
                /* Guard: Did parse return an error? */
                // if let _ = parsedResult[Constants.parseResponseKeys.StatusCode] as? Int {
                //     displayError("The parse server returned an error. See the ")
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

    // MARK: PUT
    func taskForPutMethod(method: String,
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
            
            let request = NSMutableURLRequest(URL: parseURLFromParameters(methodParameters))
            // TODO: Move the code for building the request into it's own function
            // It's OK for now, but pay attention to the way that the system for
            // building requests with bodies is done in the example cod
            request.HTTPMethod = "PUT"
            request.addValue(ParseClient.Constants.ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(ParseClient.Constants.ParseRESTApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)

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
                
                
                /* Guard: Did parse return an error? */
                // if let _ = parsedResult[Constants.parseResponseKeys.StatusCode] as? Int {
                //     displayError("The parse server returned an error. See the ")
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
    
    private func parseURLFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = Constants.ApiScheme /* Constants.Parse.ApiScheme */
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        
        print("  ***** URL ******")
        print(components.URL!)
        return components.URL!
    }
    
    // MARK: Helpers
    // given a raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            print(" ***** Parsed Result ****")
            // print(parsedResult)
            // To Do: Get this to work
            if let resultsArray = parsedResult.valueForKey("results") as? [AnyObject] {
                print(resultsArray.count)
                for (var i = 0; i < resultsArray.count; i++) {
                    if let createdAt = resultsArray[i].valueForKey("createdAt") as? String {
                        print(createdAt)
                    }
                    if let firstName = resultsArray[i].valueForKey("firstName") as? String {
                        print(firstName)
                    }
                    if let lastName = resultsArray[i].valueForKey("lastName") as? String {
                        print(lastName)
                    }
                    if let latitude = resultsArray[i].valueForKey("latitude") as? String {
                        print(latitude)
                    }
                    if let longitude = resultsArray[i].valueForKey("longitude") as? String {
                        print(longitude)
                    }
                    if let mapString = resultsArray[i].valueForKey("mapString") as? String {
                        print(mapString)
                    }
                    if let mediaURL = resultsArray[i].valueForKey("medialURL") as? String {
                        print(mediaURL)
                    }
                    if let objectId = resultsArray[i].valueForKey("objectId") as? String {
                        print(objectId)
                    }
                    if let uniqueKey = resultsArray[i].valueForKey("uniqueKey") as? String {
                        print(uniqueKey)
                    }
                    if let updatedAt = resultsArray[i].valueForKey("updatedAt") as? String {
                        print(updatedAt)
                    }
                }
            }
            print(" **** Done Parsing Result *** ")
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
}