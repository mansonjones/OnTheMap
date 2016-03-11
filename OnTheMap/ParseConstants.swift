//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Manson Jones on 2/19/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

// MARK: - ParseClient (Constants)

extension ParseClient {
    // MARK: Constants
    struct Constants {
        // MARK: API Key
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ParseRESTApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: URLS
        static let ApiScheme = "https"
        static let ApiHost = "api.parse.com"
        static let ApiPath = "/1"
    }
    
    struct Methods {
        static let StudentLocation = "/classes/StudentLocation"
    }
    
    struct ParameterKeys {
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
    }
    
    // TODO: These can probably be deleted
    struct JSONBodyKeys {
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaUrl = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let CreatedAt = "createdAt"
        static let ObjectId = "objectId"
        static let UpdatedAt = "updatedAt"
    }
    
    struct JSONResponseKeys {
        
        // This is the key that is used to extract the
        // array of student information from the
        // json object.
        
        static let StudentResults = "results"
        
        static let StatusCode = "status_code"
        
        // MARK: StudentLocation
        static let CreatedAt = "createdAt"
        static let ObjectId = "objectId"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaUrl = "mediaURL"
        static let UniqueKey = "uniqueKey"
        static let UpdatedAt = "updatedAt"
    }
    
}