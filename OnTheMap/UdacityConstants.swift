//
//  Constants.swift
//  OnTheMap
//
//  Created by Manson Jones on 2/16/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
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
    struct ParameterKeys {
        static let Users = "users"
        /*
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        */
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
        static let FacebookMobile = "facebook_mobile"
        static let FacebookAccessToken = "access_token"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        // Mark General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        static let Email = "email"
        static let Password = "password"
        //MARK: session
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
        
        // TODO: Not sure if the dot notation works for json
        
        // MARK: Udacity student information
        static let Account = "account"
        static let Key = "key"
        static let Registered = "account.registered"
        static let Expiration = "session.expiration"
        static let Id = "session.id"
        
        static let UniqueKey = "uniqueKey"
        //     static let FirstName = "firstName"
        //     static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaUrl = "mediaUrl"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let CreatedAt = "createdAt"
        static let ObjectId = "objectId"
        static let UpdatedAt = "updatedAt"
        
        
    }
}
