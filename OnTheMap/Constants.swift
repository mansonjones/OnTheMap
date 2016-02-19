//
//  Constants.swift
//  OnTheMap
//
//  Created by Manson Jones on 2/16/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import Foundation

struct Constants {
    
    // MARK: Udacity
    struct Udacity {
        static let ApiScheme = "https"
        // question: does this also work with simple udacity.com?
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
    }
    
    // MARK: Methods
    struct Methods {
        static let Session = "/session"
        static let Users = "/users"
    }
    
    // MARK: Udacity Parameter Keys
    struct UdacityParameterKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: Udacity Response Keys
    struct UdacityResponseKeys {
        static let StatusCode = "status_code"
    }
    
    // MARK: Parse
    struct Parse {
        static let ApiScheme = "https"
        static let ApiHost = "api.parse.com"
        static let ApiPath = "/1"
    }
    
    // MARK: JSONBodyKeys 
    struct JSONBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        // Mark General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        //MARK: session
        // TODO: Not sure which of these are needed.
        // TODO: Not sure if the dot notation works for json
        static let Key = "account.key"
        static let Registered = "account.registered"
        static let Expiration = "session.expiration"
        static let Id = "session.id"
    }

    
    
    
}